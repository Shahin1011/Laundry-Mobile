import 'package:flutter/material.dart';
import 'package:laundry/helpers/route.dart';
import '../../utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class HelpAndSupportScreen extends StatefulWidget{
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
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
                  "Help & Support",
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

          SizedBox(height: 20.h),

          GestureDetector(
            onTap: (){
              Get.toNamed(AppRoutes.contractUsScreen);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000).withOpacity(0.10),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Contract Us",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F1D1D),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF4D4D4D))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}