import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerNotificationCard extends StatelessWidget {
  const ShimmerNotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title placeholder
            Container(
              height: 18.h,
              width: 140.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            SizedBox(height: 10.h),

            // Description line 1
            Container(
              height: 16.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            SizedBox(height: 6.h),

            // Description line 2
            Container(
              height: 16.h,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            SizedBox(height: 12.h),

            // Date placeholder
            Container(
              height: 14.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
