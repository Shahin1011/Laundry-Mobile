import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/helpers/route.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget{
  const OnboardingScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.13),
              Center(child: SvgPicture.asset("assets/images/laundyImg.svg")),
              SizedBox(height: MediaQuery.of(context).size.height * 0.075),
              Text(
                "Welcome to\nLaundry Delivery Service\nPlatform",
                style: GoogleFonts.inter(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2B2B2B),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                "Connecting you with the best services, anytime, anywhere.\nExperience seamless support tailored just for you.",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2B2B2B),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.034),
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.locationScreen);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.mainAppColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "Get Started",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE6E6E6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already haven account? ",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2B2B2B),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Get.offAllNamed(AppRoutes.loginScreen);
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
            ],
          ),
        ),
      ),
    );
  }

}