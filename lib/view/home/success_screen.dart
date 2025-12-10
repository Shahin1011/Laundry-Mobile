import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../helpers/route.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  Timer? _timer;
  int _seconds = 3;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_seconds <= 1) {
        _goHome(context);
      } else {
        setState(() {
          _seconds -= 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goHome(BuildContext context) {
    _timer?.cancel();
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.bottomNavScreen, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/congrats.svg',
                width: 220.w,
              ),
              SizedBox(height: 24.h),
              Text(
                'Congratulations!',
                style: GoogleFonts.inter(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1D1D),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: Text(
                  'Your order has been successfully\nConfirm!!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Closing in $_seconds seconds',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: 180.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainAppColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  onPressed: () => _goHome(context),
                  child: Text(
                    'Close',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
