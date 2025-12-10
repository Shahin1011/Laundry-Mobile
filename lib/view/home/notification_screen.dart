import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laundry/view/home/widgets/notification_card.dart';
import 'package:laundry/view/home/widgets/shimmer_notification_card.dart';
import 'package:laundry/view/home/widgets/time_ago.dart';
import '../../controller/notification/notification_controller.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';



class NotificationScreen extends StatelessWidget {
   NotificationScreen({super.key});

   final controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          // 🔹 Header Section
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: BoxDecoration(
              color: AppColors.mainAppColor,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 25.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    "assets/icons/backIcon.svg",
                    width: 24.w,
                    height: 24.h,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  "Notifications",
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(),
              ],
            ),
          ),

          // 🔹 Notification List
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.builder(
                    itemCount: 6,
                    padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                    itemBuilder: (_, index) => const ShimmerNotificationCard(),
                  );
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (controller.notificationsList.isEmpty) {
                  return const Center(child: Text("No notifications found"));
                }

                return ListView.builder(
                  padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
                  itemCount: controller.notificationsList.length,
                  itemBuilder: (context, index) {
                    final n = controller.notificationsList[index];

                    return NotificationCard(
                      timeAndDate: formatNotificationTime(n.updatedAt),
                      description: n.message ?? "",
                      title: n.title ?? "",
                      notificationId: n.id!,
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

}
