import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/utils/app_colors.dart';
import 'package:get/get.dart';

import '../../../controller/notification/notification_controller.dart';

class NotificationCard extends StatelessWidget{
  final String timeAndDate;
  final String title;
  final String description;
  final String notificationId;

  const NotificationCard({super.key, required this.timeAndDate, required this.description, required this.title, required this.notificationId});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding:  EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainAppColor,
                  ),
                ),
                SizedBox(height: 10.h),

                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF5E5E5E),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 12.h),
                Text(
                  timeAndDate,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.mainAppColor,
                  ),
                ),

              ],
            ),
          ),
          GestureDetector(
            onTap: (){
              _showDeleteDialog(context);
            },
            child: SvgPicture.asset("assets/icons/threeDotIcon.svg", width: 20.w, height: 20.h),
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
                "Delete Notification",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF202020),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Are you sure to delete this notification?",
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
                      onPressed: ()async{
                         await Get.find<NotificationsController>().deleteNotification(notificationId);
                         Navigator.of(context).pop();
                      },
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