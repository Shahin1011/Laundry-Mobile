import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../helpers/route.dart';

class LaundryServiceCard extends StatelessWidget {
  const LaundryServiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Color(0xFFC8CACC),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              color: Color(0xFFE8F4F6),
            ),
            child: Image.asset('assets/images/laundryCard.png')
          ),
          SizedBox(height: 20.h),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Laundry Service',
                  style: GoogleFonts.inter(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1D1D),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'We pick up, clean, iron, fold, and deliver your clothes with care!',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF595959),
                  ),
                ),
                SizedBox(height: 24.h),
                // Button
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.choicePackageScreen);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.mainAppColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Choice Package',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

