import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../model/order_model.dart';
import '../../utils/app_contants.dart';
import '../../utils/token_service.dart';

class OrdersController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var orders = <Order>[].obs;

  final String ordersUrl = "${AppConstants.BASE_URL}/api/orders/my-orders";

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> fetchOrders() async {
    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your connection.");
      return;
    }

    final token = await TokenService().getToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "No auth token";
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(ordersUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      print("My Order RESPONSE =====================: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        final summary = OrderSummary.fromJson(jsonData);

        orders.value = summary.data?.orders ?? [];
      } else {
        errorMessage.value = "Failed: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
