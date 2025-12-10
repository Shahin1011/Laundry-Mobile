import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/utils/app_colors.dart';
import 'package:get/get.dart';
import '../../helpers/route.dart';
import '../../utils/token_service.dart';
import '../../controller/profile/profile_controller.dart';


class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await TokenService().getToken();

    if (token != null && token.isNotEmpty) {
      // Fetch profile before navigating to authenticated screen
      try {
        final profileController = Get.find<ProfileController>();
        await profileController.ensureProfileLoaded();
      } catch (e) {
        print('Error fetching profile on splash: $e');
        // Continue navigation even if profile fetch fails
      }
      Get.offAllNamed(AppRoutes.bottomNavScreen);
    } else {
      Get.offAllNamed(AppRoutes.onboardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset("assets/images/appLogo.svg"),
          ),
          SizedBox(height: 5.h),
          Text(
            "Laundry",
            style: GoogleFonts.poppins(
              fontSize: 62.sp,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Text(
            "King Express",
            style: GoogleFonts.poppins(
              fontSize: 47.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.mainAppColor,
              height: 0.7
            ),
          )
        ],
      ),
    );
  }
}