import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/helpers/route.dart';
import 'package:laundry/view/auth/login_screen.dart';
import 'package:laundry/view/auth/widget/otp_timer_widget.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_contants.dart';


class OTPScreen extends StatefulWidget{
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  late String email;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    email = args["email"];
  }


  bool isLoading = false;
  final TextEditingController pinController = TextEditingController();

  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<bool> verifyUser(String email, String code) async {
    final url = "${AppConstants.BASE_URL}/api/auth/verify-otp";

    if (!await hasInternetConnection()) {
      Get.snackbar("No Internet", "Please check your internet connection.");
      return false;
    }

    final body = {'emailOrPhone': email, 'otp': code};
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
        Get.snackbar(
          "Success",
          data["message"] ?? "OTP Verified successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.off(() => LoginScreen());
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      "OTP Verify",
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
                SvgPicture.asset("assets/images/otpImg.svg"),
                SizedBox(height: MediaQuery.of(context).size.height * 0.030),
                Text(
                  "Enter Verification Code",
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1D1D),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "We’ve sent a 6-digit code to $email",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF3C3C3C),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.059),
            
                PinCodeEnter(context),
            
                GestureDetector(
                  onTap: (){
                    final otp = pinController.text.trim();
                    verifyUser(email, otp);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: AppColors.mainAppColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Verify",
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


                ///Resend OTP Timer
                OtpTimerWidget(),
            
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "Didn't receive the code? ",
                //         style: GoogleFonts.inter(
                //           fontSize: 14.sp,
                //           fontWeight: FontWeight.w400,
                //           color: Color(0xFF2B2B2B),
                //         ),
                //       ),
                //       InkWell(
                //         onTap: (){
                //
                //         },
                //         child: Text(
                //           "Resend",
                //           style: GoogleFonts.inter(
                //             fontSize: 15.sp,
                //             fontWeight: FontWeight.w600,
                //             color: Color(0xFF2B2B2B),
                //           ),
                //         ),
                //       ),
                //     ]
                // ),
                SizedBox(height: 8.h),
            
                Center(
                  child: InkWell(
                    onTap: (){
                      Get.toNamed(AppRoutes.loginScreen);
                    },
                    child: Text(
                      "Back to Login",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF060504),
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
    );
  }

  PinCodeTextField PinCodeEnter(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      enableActiveFill: true,
      showCursor: true,
      cursorColor: AppColors.mainAppColor,
      obscureText: false,
      textStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.mainAppColor,
        //fontFamily: "Satoshi",
      ),
      controller: pinController,
      animationType: AnimationType.scale,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        borderWidth: 0.5,
        fieldHeight: 45.h,
        fieldWidth: 45.w,
        fieldOuterPadding: EdgeInsets.symmetric(horizontal: 4),
        inactiveColor: Color(0xFF5E5E5E),
        inactiveFillColor: AppColors.white,
        selectedFillColor: Colors.white,
        disabledColor: AppColors.white,
        activeFillColor: Colors.white,
        selectedColor: AppColors.mainAppColor,
        activeColor: AppColors.mainAppColor,
      ),
      hintCharacter: '-',
      animationDuration: const Duration(milliseconds: 100),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      onChanged: (value) {
        // _controller.otpCode.value = value;
      },
      onCompleted: (value) {
        print("Entered Code: $value");
      },
    );
  }
}