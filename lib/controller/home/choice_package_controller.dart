import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/utils/app_colors.dart';
import 'dart:convert';
import '../../model/choice_package_model.dart';
import '../../utils/app_contants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'booking_controller.dart';

class ChoicePackageController extends GetxController {
  RxBool isLoading = true.obs;
  var errorMessage = ''.obs;
  RxList<Data> packages = <Data>[].obs;

  // For multiple selected bags - store in a map with bag id as key
  var selectedBags = <String, BagSelection>{}.obs;

  final String packageUrl = "${AppConstants.BASE_URL}/api/packages";

  @override
  void onInit() {
    fetchPackages();
    super.onInit();
  }

  final BookingController bookingController = Get.find<BookingController>();

  void toggleBagSelection(BagOption bag) {
    final bagId = bag.id;

    if (bookingController.selectedBags.containsKey(bagId)) {
      // Remove from booking controller
      bookingController.removeBag(bagId);
    } else {
      // Add to booking controller with quantity 1
      bookingController.addBagSelection(
        bagId,
        bag.name,
        bag.weight,
        bag.serviceFee,
        bag.price,
        1,
      );
    }

    printSelectedBags();
  }

  void updateBagQuantity(String bagId, int newQuantity) {
    if (bookingController.selectedBags.containsKey(bagId)) {
      bookingController.updateBagQuantity(bagId, newQuantity);
    }
  }

  bool isBagSelected(String bagId) {
    return bookingController.selectedBags.containsKey(bagId);
  }

  BagSelection? getBagSelection(String bagId) {
    return bookingController.selectedBags[bagId];
  }

  void printSelectedBags() {
    print("=== Selected Bags ===");
    bookingController.selectedBags.forEach((id, bag) {
      print(
          "Bag ID: $id, "
              "Name: ${bag.name}, "
              "Quantity: ${bag.quantity}, "
              "Price per bag: ${bag.price}, "
              "Total: ${bag.totalPrice}"
      );
    });
    print("====================");
  }

  // Update validation to use booking controller
  bool validateSelection() {
    if (bookingController.selectedBags.isEmpty) {
      Get.snackbar(
        "No Bag Selected",
        "Please select at least one bag before continuing.",
        backgroundColor: Color(0xFFFF5656),
        colorText: AppColors.white,
      );
      return false;
    }
    return true;
  }

  // Get total from booking controller
  double getTotalPrice() {
    return bookingController.getTotalPrice();
  }

  int getTotalBags() {
    return bookingController.getTotalBags();
  }


  // Fetch Packages get api
  Future<void> fetchPackages() async {
    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your connection.");
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(packageUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        ChoicePackageModel model = ChoicePackageModel.fromJson(jsonData);
        packages.value = model.data ?? [];
      } else {
        errorMessage.value = "Failed: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}

class BagOption {
  String id;
  String name;
  String weight;
  double price;
  double serviceFee;
  String description;

  BagOption({
    required this.id,
    required this.name,
    required this.weight,
    required this.price,
    double? serviceFee,
    required this.description,
  }) : serviceFee = serviceFee ?? 0;
}
