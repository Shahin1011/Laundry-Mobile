import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controller/order/orders_controller.dart';
import '../../controller/profile/profile_controller.dart';
import '../../utils/app_colors.dart';
import 'widgets/home_header_widget.dart';
import 'widgets/laundry_service_card.dart';
import 'widgets/recent_order_card.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OrdersController c = Get.put(OrdersController());
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // Ensure profile is loaded when home screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.ensureProfileLoaded();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          // Header
          HomeHeaderWidget(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Laundry Service Card
                  LaundryServiceCard(),
                  
                  SizedBox(height: 15.h),
                  
                  // Recent Order Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Recent order',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1D1D),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  
                  // Recent Order Card
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    child: Obx((){
                      if (c.isLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (c.errorMessage.isNotEmpty) {
                        return Center(child: Text(c.errorMessage.value));
                      }

                      // Filter: Remove completed and cancelled orders
                      final filteredOrders = c.orders.where(
                              (order) {
                            final status = order.status?.toLowerCase() ?? "";
                            return status != "completed" && status != "cancelled";
                          }
                      ).toList();

                      if (filteredOrders.isEmpty) {
                        return const Center(
                            child: Text("No ongoing orders found"),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index){
                          final order = filteredOrders[index];
                          return RecentOrderCard(
                            orderId: order.id ?? "",
                            currentStage: order.status ?? "",
                            progressPercentage: getProgress(order.status ?? ""),
                          );
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  double getProgress(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return 0.05;
      case "pickup":
        return 0.25;
      case "washing":
        return 0.60;
      case "delivery":
        return 0.95;
      case "completed":
        return 1.00;
      default:
        return 0.0;
    }
  }

}
