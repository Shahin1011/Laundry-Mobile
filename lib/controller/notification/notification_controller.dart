import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../model/notification_model.dart';
import '../../utils/app_contants.dart';
import '../../utils/token_service.dart';

class NotificationsController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var notificationsList = <Notifications>[].obs;

  final String notificationsUrl = "${AppConstants.BASE_URL}/api/notifications";

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Fetch notifications
  Future<void> fetchNotifications({int page = 1, int limit = 10}) async {
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
        Uri.parse("$notificationsUrl?page=$page&limit=$limit"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final model = NotificationsModel.fromJson(jsonData);
        notificationsList.value = model.data?.notifications ?? [];
      } else {
        errorMessage.value = "Failed: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
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
      final response = await http.delete(
        Uri.parse("$notificationsUrl/$notificationId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        notificationsList.removeWhere((n) => n.id == notificationId);
        Get.snackbar("Success", "Notification deleted successfully");
      } else {
        Get.snackbar("Failed", "Failed to delete: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
