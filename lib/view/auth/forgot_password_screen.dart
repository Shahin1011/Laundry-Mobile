import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../helpers/route.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_contants.dart';
import '../components/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  /// Check Internet
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Forgot Password API
  Future<void> forgotPassword(String email) async {
    if (!_formKey.currentState!.validate()) return;

    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection");
      return;
    }

    final url = "${AppConstants.BASE_URL}/api/auth/forgot-password";

    setState(() => isLoading = true);

    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(
          AppRoutes.otpVerifyForForgotPass,
          arguments: {"email": email},
        );
      } else {
        Get.snackbar(
          "Failed",
          data['message'] ?? "Something went wrong",
        );
      }
    } on TimeoutException {
      Get.snackbar(
        "Timeout",
        "Server is taking too long. Please try again",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong",
      );
    } finally {
      setState(() => isLoading = false);
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
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  /// Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          "assets/icons/backIcon.svg",
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                      Text(
                        "Forgot Password",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.10),

                  Text(
                    "Forgot Password?",
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Don’t worry! Enter your registered email",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF595959),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                  Text(
                    "Enter your e-mail",
                    style: GoogleFonts.inter(fontSize: 14.sp),
                  ),
                  SizedBox(height: 8.h),

                  /// Email Field
                  CustomTextField(
                    textEditingController: emailController,
                    hintText: 'example@gmail.com',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    fillColor: Colors.white,
                    fieldBorderColor: AppColors.borderColor,
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  /// Submit Button
                  GestureDetector(
                    onTap: isLoading
                        ? null
                        : () => forgotPassword( emailController.text.trim(),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.mainAppColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        isLoading ? "Loading..." : "Send Reset Code",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE6E6E6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                  /// Login redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Remembered your password? ",
                        style: GoogleFonts.inter(fontSize: 14.sp),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.loginScreen);
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
