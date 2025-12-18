import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/app_colors.dart';


class OtpTimerWidget extends StatefulWidget {
  @override
  _OtpTimerWidgetState createState() => _OtpTimerWidgetState();
}

class _OtpTimerWidgetState extends State<OtpTimerWidget> {
  int _seconds = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _seconds = 60;
    _canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void resendOtp() {
    // OTP resend logic goes here
    print("OTP Resent!");
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _canResend
          ? InkWell(
        onTap: resendOtp,

        child: Text(
          "Resend OTP",
          style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary
          ),
        ),
      )
          : RichText(
          text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textColor_01,
              ),
              children: [
                TextSpan(text: "Wait "),
                TextSpan(
                  text: "$_seconds",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
                TextSpan(text: " Seconds to resend OTP")
              ]
          )
      ),
    );
  }
}
