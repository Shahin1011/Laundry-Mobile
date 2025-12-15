import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:laundry/helpers/route.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_contants.dart';
import '../../utils/token_service.dart';
import '../components/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';



class NewPasswordScreen extends StatefulWidget{
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  String? resetToken;

  bool isLoading = false;
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    resetToken = args?["resetToken"];
  }


  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _setNewPassword (String resetToken, String newPassword, String confirmPassword) async {
    final updatePassUrl = "${AppConstants.BASE_URL}/api/auth/set-new-password";

    if (!_formKey.currentState!.validate()) return;

    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return;
    }


    final body = {
      'resetToken' : resetToken,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };

    setState(() { isLoading = true; });

    try {
      final response = await http.post(
        Uri.parse(updatePassUrl),
        headers: {
          'Content-Type': 'application/json',
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
        Get.offAllNamed(AppRoutes.loginScreen);

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset("assets/icons/backIcon.svg", width: 24.w, height: 24.h),
                      ),
                      Text(
                        "New Password",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F1D1D),
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  Text(
                    "Set a new Password?",
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1D1D),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Please set a new password for your account to\ncontinue",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF595959),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.059),

                  Text(
                    "New Password",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF303030),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    textEditingController: newPassController,
                    hintText: 'New Password',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: AppColors.subHeadingColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a new password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    isPassword: true,
                    fillColor: Color(0xFFFFFFFF),
                    fieldBorderColor: AppColors.borderColor,
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    "Confirm password",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF303030),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    textEditingController: confirmPassController,
                    hintText: 'Confirm password',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: AppColors.subHeadingColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      } else if (newPassController.text != confirmPassController.text) {
                        return "Password Mismatch";
                      }
                      return null;
                    },
                    isPassword: true,
                    fillColor: Color(0xFFFFFFFF),
                    fieldBorderColor: AppColors.borderColor,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () {
                      if (resetToken == null || resetToken!.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Reset token missing. Please verify OTP again.",
                        );
                        return;
                      }

                      _setNewPassword(
                        resetToken!,
                        newPassController.text.trim(),
                        confirmPassController.text.trim(),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.mainAppColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Update Password",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE6E6E6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}