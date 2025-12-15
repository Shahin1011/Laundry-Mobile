import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/profile/profile_controller.dart';
import '../../../helpers/route.dart';
import '../../../utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';


class HomeHeaderWidget extends StatelessWidget {
  HomeHeaderWidget({super.key});

  final ProfileController c = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = c.profile.value;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.mainAppColor,
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              // Profile Picture
              Container(
                width: 45.w,
                height: 45.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: (profile != null && profile.profileImage.isNotEmpty)
                      ? CachedNetworkImage(
                    imageUrl: profile.profileImage,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      "assets/images/emptyUser.png",
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/emptyUser.png",
                      fit: BoxFit.cover,
                    ),
                  )
                      : Image.asset(
                    "assets/images/emptyUser.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // User Greeting
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${profile?.fullname ?? ''}',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Notification Icon
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                child: Container(
                  width: 38.w,
                  height: 38.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}


