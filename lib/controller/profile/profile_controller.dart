import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:laundry/helpers/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/profile_model.dart';
import '../../utils/app_contants.dart';
import '../../utils/token_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var profile = Rxn<ProfileModel>();

  final String profileUrl = "${AppConstants.BASE_URL}/api/user/profile";

  @override
  void onInit() {
    super.onInit();
    // Don't fetch immediately - wait for user to be authenticated
    // Profile will be fetched when user navigates to authenticated screens or after login
  }

  /// Manually trigger profile fetch (call this after login or when navigating to authenticated screens)
  Future<void> ensureProfileLoaded() async {
    // If profile is already loaded and not stale, don't fetch again
    if (profile.value != null && !isLoading.value) {
      print('ProfileController: Profile already loaded, skipping fetch');
      return;
    }

    // If already loading, don't fetch again
    if (isLoading.value) {
      print('ProfileController: Profile already loading, skipping duplicate fetch');
      return;
    }

    final token = await TokenService().getToken();
    if (token != null && token.isNotEmpty) {
      print('ProfileController: Token available, fetching profile...');
      await fetchProfile();
    } else {
      print('ProfileController: No token available, cannot fetch profile');
      errorMessage.value = "Not authenticated";
    }
  }

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> fetchProfile() async {
    print('ProfileController: fetchProfile() called');
    
    if (!await hasInternetConnection()) {
      print('ProfileController: No internet connection');
      errorMessage.value = "No internet connection";
      // Don't show snackbar on initial load, only set error message
      return;
    }

    final token = await TokenService().getToken();
    if (token == null || token.isEmpty) {
      print('ProfileController: No authentication token available');
      errorMessage.value = "No authentication token";
      return;
    }

    print('ProfileController: Fetching profile from: $profileUrl');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse(profileUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print('ProfileController: Response status: ${response.statusCode}');
      print('ProfileController: Response body: ${response.body}');

      if (response.statusCode != 200) {
        final errorBody = response.body;
        print('ProfileController: API Error - Status: ${response.statusCode}, Body: $errorBody');
        errorMessage.value = "Failed to load profile: ${response.statusCode}";
        // Don't show snackbar on initial load
        return;
      }

      final jsonData = json.decode(response.body);
      print('ProfileController: Parsed JSON: $jsonData');

      if (jsonData["success"] == false) {
        final errorMsg = jsonData["message"] ?? "Failed to load profile";
        print('ProfileController: API returned success=false: $errorMsg');
        errorMessage.value = errorMsg;
        return;
      }

      final data = jsonData["data"];
      if (data == null) {
        print('ProfileController: No data field in response');
        errorMessage.value = "No profile data received";
        return;
      }

      print('ProfileController: Creating ProfileModel from data: $data');
      profile.value = ProfileModel.fromJson(data);
      print('ProfileController: Profile loaded successfully: ${profile.value?.fullname}');
      errorMessage.value = ''; // Clear any previous errors

    } catch (e, stackTrace) {
      print('ProfileController: Exception occurred: $e');
      print('ProfileController: Stack trace: $stackTrace');
      errorMessage.value = "Failed to load profile: $e";
    } finally {
      isLoading.value = false;
      print('ProfileController: fetchProfile() completed. isLoading: ${isLoading.value}, profile: ${profile.value != null ? "loaded" : "null"}');
    }
  }

  Future<void> logout() async {
    await TokenService().clearToken();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("password");
    await prefs.remove("isLoggedIn");

    Get.offAllNamed(AppRoutes.loginScreen);
  }
}
