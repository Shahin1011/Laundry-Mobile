import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../model/order_details_model.dart';
import '../../utils/app_contants.dart';
import '../../utils/token_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class OrderDetailsController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var orderDetails = Rxn<OrderDetailsModel>();

  // Example endpoint: GET /api/orders/:id
  Future<void> fetchOrderDetails(String orderId) async {

    if (!await _hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }

    final token = await TokenService().getToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "No authentication token";
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse("${AppConstants.BASE_URL}/api/orders/$orderId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("My Order Details RESPONSE =====================: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        orderDetails.value = OrderDetailsModel.fromJson(jsonData);
      } else {
        errorMessage.value =
        "Failed to fetch order details: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


  /// For CanelOrder
  Future<void> cancelOrder(String orderId) async {
    if (!await _hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your connection.");
      return;
    }

    isLoading.value = true;

    try {
      final token = await TokenService().getToken();
      final url = "${AppConstants.BASE_URL}/api/orders/$orderId/cancel";
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Order cancelled successfully");
        // Refresh order details
        fetchOrderDetails(orderId);
      } else {
        Get.snackbar("Failed", "Failed to cancel order: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

}
