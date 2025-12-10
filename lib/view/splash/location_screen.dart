import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/helpers/route.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';

class LocationScreen extends StatelessWidget{
  const LocationScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
       child: Padding(
         padding: EdgeInsets.symmetric(horizontal: 20.w),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Center(child: SvgPicture.asset("assets/images/locationImg.svg")),
             SizedBox(height: MediaQuery.of(context).size.height * 0.029),
             Text(
               "Allow Location Access",
               style: GoogleFonts.inter(
                 fontSize: 20.sp,
                 fontWeight: FontWeight.w600,
                 color: Color(0xFF2B2B2B),
               ),
               textAlign: TextAlign.center,
             ),
             SizedBox(height: 10.h),
             Text(
               "To help you find the best service\nproviders near you, please share your\nlocation.",
               style: GoogleFonts.inter(
                 fontSize: 12.sp,
                 fontWeight: FontWeight.w400,
                 color: Color(0xFF595959),
               ),
               textAlign: TextAlign.center,
             ),
             SizedBox(height: MediaQuery.of(context).size.height * 0.045),
             GestureDetector(
               onTap: (){
                 Get.offAllNamed(AppRoutes.loginScreen);
               },
               child: Container(
                 width: double.infinity,
                 padding: EdgeInsets.symmetric(vertical: 10.h),
                 decoration: BoxDecoration(
                   color: AppColors.mainAppColor,
                   borderRadius: BorderRadius.circular(8.r),
                 ),
                 child: Text(
                   "Allow location access",
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
      ),
    );
  }

}