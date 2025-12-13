import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laundry/view/myOrder/myOreder_screen.dart';
import 'package:laundry/view/profile/profile_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_icons.dart';
import '../home/home_screen.dart';




class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int selectedIndex = 0;

  void navigationItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
     HomeScreen(),
     MyOrderScreen(),
     ProfileScreen(),

  ];

  // Create nav items in a getter
  List<BottomNavigationBarItem> get _navItems => [
    _navItem(AppIcons.homeNavIcon, "Home", 0),
    _navItem(AppIcons.myOrederICon, "My Order", 1),
    _navItem(AppIcons.profileIcon, "Profile", 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],

      // 🎯 MODIFICATION: Wrap the BottomNavigationBar in a SizedBox
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.08),
              offset: const Offset(4, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          border: const Border(
            top: BorderSide(
              color: Color(0xFFEAEAEA),
              width: 1.5,
            ),
          ),
        ),
        height: 100.h,
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          selectedItemColor: AppColors.mainAppColor,
          selectedLabelStyle: TextStyle(
            fontFamily: 'SegeoUi_bold',
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            color: AppColors.mainAppColor,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'SegeoUi_bold',
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.foundationColor,
          ),
          showSelectedLabels: true,
          unselectedItemColor: AppColors.foundationColor,
          backgroundColor: Colors.white,
          onTap: navigationItemTap,
          items: _navItems,
        ),
      ),
    );
  }

  // 🎯 FIX: Simplified _navItem and added color logic for SVG
  BottomNavigationBarItem _navItem(
      String iconPath, // Only one path needed
      String label,
      int index,
      ) {

    final bool isSelected = selectedIndex == index;
    final Color iconColor = isSelected
        ? AppColors.mainAppColor
        : AppColors.foundationColor;

    return BottomNavigationBarItem(
      // 🎯 FIX: Removed the unnecessary Column and SizedBox(height: 10.h)
      icon: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            // This ensures the icon color changes with selection state
          ),
          SizedBox(height: 4.h),
        ],
      ),
      label: label,
    );
  }
}