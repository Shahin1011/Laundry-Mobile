import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_contants.dart';
import '../../utils/token_service.dart';
import '../components/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';


class ChangePasswordScreen extends StatefulWidget{

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  bool isLoading = false;
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newpPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _updatePassword (String currentPassword, String newPassword, String confirmPassword) async {
    final updatePassUrl = "${AppConstants.BASE_URL}/api/user/update-password";

    if (!_formKey.currentState!.validate()) return;

    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }

    final token = await TokenService().getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Alert", "No authentication token");
      return;
    }

    final body = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    setState(() { isLoading = true; });

    try {
      final response = await http.put(
        Uri.parse(updatePassUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(body),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          data["message"] ?? "updated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        //Get.offNamed(AppRoutes.bottomNavScreen);

      } else {
        Get.snackbar("Error", data['message'] ?? "Login failed", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: BoxDecoration(
              color: AppColors.mainAppColor,
            ),
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 25.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    "assets/icons/backIcon.svg",
                    width: 24.w,
                    height: 24.h,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  "Change Password",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(),
              ],
            ),
          ),

          Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.055),

                      Text(
                        "Current Password",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2B4237),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        textEditingController: currentPassController,
                        hintText: '********',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Color(0xFF737373),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your current password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        isPassword: true,
                        fillColor: Color(0xFF1C5941).withOpacity(0.03),
                        fieldBorderColor: AppColors.mainAppColor,
                      ),
                      SizedBox(height: 16.h),


                      Text(
                        "New Password",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2B4237),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        textEditingController: newpPassController,
                        hintText: '********',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Color(0xFF737373),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your a new password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        isPassword: true,
                        fillColor: Color(0xFF1C5941).withOpacity(0.03),
                        fieldBorderColor: AppColors.mainAppColor,
                      ),
                      SizedBox(height: 16.h),

                      Text(
                        "Confirm Password",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2B4237),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      CustomTextField(
                        textEditingController: confirmPassController,
                        hintText: '********',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          color: Color(0xFF737373),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          } else if (newpPassController.text != confirmPassController.text) {
                            return "Password Mismatch";
                          }
                          return null;
                        },
                        isPassword: true,
                        fillColor: Color(0xFF1C5941).withOpacity(0.03),
                        fieldBorderColor: AppColors.mainAppColor,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.044),

                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () {
                          _updatePassword(
                            currentPassController.text.trim(),
                            newpPassController.text.trim(),
                            newpPassController.text.trim(),
                          );},
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: AppColors.mainAppColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            isLoading ? "Loading..." : "Change Password",
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFE6E6E6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          )

        ],
      ),
    );
  }
}