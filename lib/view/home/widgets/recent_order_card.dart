import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import 'package:progress_line/progress_line.dart';

class RecentOrderCard extends StatelessWidget {
  final String orderId;
  final String currentStage;
  final double progressPercentage;

  const RecentOrderCard({
    super.key,
    required this.orderId,
    required this.currentStage,
    required this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {

    
    return Container(
      margin: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Color(0xFFC8CACC),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order id : $orderId',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F1D1D),
            ),
          ),
          SizedBox(height: 24.h),
          // Progress Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStageIcon('Pickup', 'assets/icons/pickup.svg', 0),
              _buildStageIcon('Washing', 'assets/icons/washing.svg', 1),
              _buildStageIcon('Delivery', 'assets/icons/delivery.svg', 2),
            ],
          ),
          SizedBox(height: 20.h),
          // Progress Bar
          ProgressLineWidget(
            percent: progressPercentage,
            lineColors: const [
              AppColors.mainAppColor,
            ],
            bgColor: Colors.grey.withOpacity(0.7),
            width: double.infinity,
          ),

        ],
      ),
    );
  }

  Widget _buildStageIcon(String label, String iconPath, int index) {
    
    return Column(
      children: [
          Center(
            child: SvgPicture.asset(
              iconPath,
              width: 28.w,
              height: 28.h,
              colorFilter: ColorFilter.mode(
                AppColors.mainAppColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        // ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.mainAppColor,
          ),
        ),
      ],
    );
  }

}

