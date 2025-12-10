import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/helpers/route.dart';
import 'package:laundry/utils/app_colors.dart';
import 'package:get/get.dart';


class MyOrderCard extends StatelessWidget {
  final String updatedDate;
  final String price;
  final String status;
  final String orderId; // added

  const MyOrderCard({
    super.key,
    required this.updatedDate,
    required this.price,
    required this.status,
    required this.orderId,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.20),
            offset: Offset(0, 2),
            blurRadius: 4,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Laundry Service",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F1D1D),
                ),
              ),
              Text(
                updatedDate,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1F1D1D),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            "clean, iron, fold, and deliver your clothes with care!",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF757575),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Price: \$${(int.tryParse(price) ?? 0)}",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainAppColor,
                ),
              ),
              Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: status.toLowerCase() == "cancelled"
                      ? Colors.red
                      : status.toLowerCase() == "completed"
                      ? Color(0xFF45DE6E)
                      : status.toLowerCase() == "pending"
                      ? Colors.orange
                      : status.toLowerCase() == "pickup"
                      ? Colors.blue
                      : status.toLowerCase() == "washing"
                      ? Colors.purple
                      : status.toLowerCase() == "delivery"
                      ? Colors.teal
                      : Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                // Navigate to details screen with order ID
                Get.toNamed(AppRoutes.orderDetailsScreen, arguments: orderId);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 25.w),
                decoration: BoxDecoration(
                  color: AppColors.mainAppColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "Details",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
