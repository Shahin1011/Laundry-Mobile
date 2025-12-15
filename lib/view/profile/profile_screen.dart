import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/profile/profile_controller.dart';
import '../../utils/app_colors.dart';
import '../../helpers/route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/token_service.dart';



class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController c = Get.put(ProfileController());
  late final profile = c.profile.value;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          // ----------- Header ----------
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: BoxDecoration(color: AppColors.mainAppColor),
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 25.h),
            child: Center(
              child: Text(
                "Profile",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          // ----------- Body ----------
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Obx((){

                    if (c.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final profile = c.profile.value;

                    // if (profile == null) {
                    //   return Center(child: Text("No profile data"));
                    // }
                    return RefreshIndicator(
                      onRefresh: c.fetchProfile,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.055),
                              // ----------- Profile Image ----------
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.mainAppColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.grey[200],
                                    child: ClipOval(
                                      child: profile == null
                                          ? Image.asset(
                                        "assets/images/emptyUser.png",
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      )
                                          : CachedNetworkImage(
                                        imageUrl: profile.profileImage,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            width: 110,
                                            height: 110,
                                            decoration: const BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Image.asset(
                                          "assets/images/emptyUser.png",
                                          width: 110,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 8.h),

                              // ----------- Name & Email / No Profile Data ----------
                              profile == null
                                  ? Column(
                                children: [
                                  Text(
                                    "No Profile Data",
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                                  : Column(
                                children: [
                                  Text(
                                    profile.fullname,
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    profile.email,
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    );
                  }),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                  // ----------- Account Information ----------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.10),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Information",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1F1D1D),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.editProfileScreen, arguments: profile);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/editProfileIcon.svg"),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "Edit Profile",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF4D4D4D),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF4D4D4D))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ----------- Settings ----------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.10),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Settings",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1F1D1D),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.025),

                        // Help & Support
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.helpAndSupportScreen),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/help&Support.svg"),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "Help & Support",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF4D4D4D),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF4D4D4D))
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Change password
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.changePasswordScreen);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset("assets/icons/padlock.png", width: 24.w, height: 24.h, color: Color(0xFF595959)),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "Change Password",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF4D4D4D),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF4D4D4D))
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),


                        // Logout
                        GestureDetector(
                          onTap: () => c.logout(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/logoutIcon.svg"),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "Log Out",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF4D4D4D),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF4D4D4D))
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: (){
                            _showDeleteDialog(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/deleteIcon.svg"),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "Delete Account",
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFFF6363),
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF4D4D4D))
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- Delete Confirmation Dialog --------------------
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: SvgPicture.asset("assets/icons/deleteIcon.svg"),
              ),
              SizedBox(height: 12.h),
              Text(
                "Delete Account",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF202020),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Are you sure to delete this account?",
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF494949),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontFamily: 'Prompt_regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



