import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_icons.dart';
import '../../../helpers/route.dart';

class BottomNavWidget extends StatelessWidget {
  final String currentRoute;

  const BottomNavWidget({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: AppIcons.homeNavIcon,
              label: 'Home',
              route: AppRoutes.homeScreen,
              isActive: currentRoute == AppRoutes.homeScreen,
            ),
            _buildNavItem(
              icon: AppIcons.myOrederICon,
              label: 'My Order',
              route: AppRoutes.myOrderScreen,
              isActive: currentRoute == AppRoutes.myOrderScreen,
            ),
            _buildNavItem(
              icon: AppIcons.profileIcon,
              label: 'Profile',
              route: AppRoutes.profileScreen,
              isActive: currentRoute == AppRoutes.profileScreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Get.offNamed(route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
            colorFilter: ColorFilter.mode(
              isActive ? AppColors.mainAppColor : Color(0xFF9CA3AF),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: isActive ? AppColors.mainAppColor : Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

