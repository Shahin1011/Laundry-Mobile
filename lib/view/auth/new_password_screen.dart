import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/helpers/route.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../components/custom_text_field.dart';
import 'package:get/get.dart';

class NewPasswordScreen extends StatefulWidget{
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {

  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();


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
                  isPassword: true,
                  fillColor: Color(0xFFFFFFFF),
                  fieldBorderColor: AppColors.borderColor,
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                GestureDetector(
                  onTap: (){
                    Get.toNamed(AppRoutes.loginScreen);
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
    );
  }
}