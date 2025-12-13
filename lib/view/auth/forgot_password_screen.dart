import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/helpers/route.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_contants.dart';
import '../components/custom_text_field.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';


class ForgotPasswordScreen extends StatefulWidget{
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> forgotPassword(String email) async {
    final url = "${AppConstants.BASE_URL}/api/auth/forgot-password";
    if (!_formKey.currentState!.validate()) return false;

    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return false;
    }

    final body = {'email': email};
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(AppRoutes.otpVerifyForForgotPass, arguments: { "email": email});
        return true;
      } else {
        String message = "Code wrong";
        try {
          final body = jsonDecode(response.body);
          message = body['message'] ?? message;
        } catch (_) {}
        Get.snackbar("Failed", message);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
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
                        "Forgot Password",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F1D1D),
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.10),
                  Text(
                    "Forgot Password?",
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1D1D),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Don’t worry! Enter your registered email",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF595959),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.059),
              
                  Text(
                    "Enter your e-mail",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF303030),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextField(
                    textEditingController: emailController,
                    hintText: 'example@gmail.com',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: AppColors.subHeadingColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!RegExp(
                          r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                          .hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                    fillColor: Color(0xFFFFFFFF),
                    fieldBorderColor: AppColors.borderColor,
                  ),
              
                  SizedBox(height: MediaQuery.of(context).size.height * 0.030),
              
                  GestureDetector(
                    onTap: (){
                      forgotPassword(emailController.text.trim());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.mainAppColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Send Reset Code",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE6E6E6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.044),
              
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remembered your password? ",
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF2B2B2B),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Get.toNamed(AppRoutes.loginScreen);
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2B2B2B),
                            ),
                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: 5.h),
              
                  Center(
                    child: InkWell(
                      onTap: (){
                        Get.toNamed(AppRoutes.loginScreen);
                      },
                      child: Text(
                        "Need Help?",
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2B2B2B),
                        ),
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