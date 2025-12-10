import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../utils/app_contants.dart';
import '../../utils/token_service.dart';


class BookingController extends GetxController {
  // Selected bags from choice package screen
  RxMap<String, BagSelection> selectedBags = <String, BagSelection>{}.obs;

  // User information
  RxString fullName = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString address = ''.obs;
  RxString city = ''.obs;
  RxString state = ''.obs;
  RxString zipCode = ''.obs;

  // Date and time
  Rx<DateTime?> pickupDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> pickupTime = Rx<TimeOfDay?>(null);
  Rx<DateTime?> dropoffDate = Rx<DateTime?>(null);
  Rx<TimeOfDay?> dropoffTime = Rx<TimeOfDay?>(null);

  // Payment method
  RxString paymentMethod = ''.obs;

  // Booking loading state
  RxBool isSubmitting = false.obs;
  RxString bookingError = ''.obs;

  // Bag data structure
  void addBagSelection(String bagId, String name, String weight, int price, int quantity) {
    selectedBags[bagId] = BagSelection(
      bagId: bagId,
      name: name,
      weight: weight,
      price: price,
      quantity: quantity,
    );
  }

  void updateBagQuantity(String bagId, int quantity) {
    if (selectedBags.containsKey(bagId)) {
      selectedBags[bagId]!.quantity = quantity;
      selectedBags.refresh();
    }
  }

  void removeBag(String bagId) {
    selectedBags.remove(bagId);
  }

  void clearAllBags() {
    selectedBags.clear();
  }

  // Get total price calculation
  double getTotalPrice() {
    double total = 0;
    selectedBags.forEach((id, bag) {
      total += (bag.price * bag.quantity);
    });
    return total;
  }

  int getTotalBags() {
    int total = 0;
    selectedBags.forEach((id, bag) {
      total += bag.quantity;
    });
    return total;
  }

  // Format date for API
  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format time for API
  String formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // Prepare booking data - FIXED METHOD
  Map<String, dynamic> prepareBookingData({bool forStripePayment = false}) {
    List<Map<String, dynamic>> bagsList = selectedBags.entries.map((entry) {
      return {
        'bagId': entry.key,
        'quantity': entry.value.quantity,
      };
    }).toList();

    final bookingData = {
      "pickupDate": formatDate(pickupDate.value),
      "pickupTime": formatTime(pickupTime.value),
      "dropoffDate": formatDate(dropoffDate.value),
      "dropoffTime": formatTime(dropoffTime.value),
      "fullName": fullName.value,
      "email": email.value,
      "phone": phone.value,
      "address": address.value,
      "city": city.value,
      "state": state.value,
      "zipCode": zipCode.value,
      "bags": bagsList,
    };

    // Set payment method - backend now supports Stripe without card details
    bookingData["paymentMethod"] = paymentMethod.value;

    return bookingData;
  }

  // Submit booking to API
  Future<Map<String, dynamic>> submitBooking({bool forStripePayment = false}) async {
    isSubmitting.value = true;
    bookingError.value = '';

    try {
      if (!await hasInternetConnection()) {
        throw Exception('No internet connection');
      }

      final bookingData = prepareBookingData(forStripePayment: forStripePayment);

      // Validate required fields
      if (bookingData['pickupDate'].isEmpty ||
          bookingData['pickupTime'].isEmpty ||
          bookingData['fullName'].isEmpty ||
          bookingData['email'].isEmpty ||
          bookingData['phone'].isEmpty ||
          bookingData['address'].isEmpty ||
          bookingData['paymentMethod'].isEmpty ||
          selectedBags.isEmpty) {
        throw Exception('Please fill all required fields');
      }

      final token = await TokenService().getToken();
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}/api/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(bookingData),
      );

      print('Booking response status =========================================================>>: ${response.statusCode}');
      print('Booking response body ==========================================================>>: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        isSubmitting.value = false;
        return {
          'success': true,
          'data': responseData,
          'message': 'Booking created successfully!',
        };
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Failed to create booking';
        print("${response.body}");
        throw Exception(errorMessage);
        
      }
    } catch (e) {
      isSubmitting.value = false;
      bookingError.value = e.toString();
      print("Erorr:$e");
      return {
        'success': false,
        'error': e.toString(),
        'message': e.toString(),
      };
    }
  }

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}

class BagSelection {
  String bagId;
  String name;
  String weight;
  int price;
  int quantity;

  BagSelection({
    required this.bagId,
    required this.name,
    required this.weight,
    required this.price,
    required this.quantity,
  });

  int get totalPrice => price * quantity;
}