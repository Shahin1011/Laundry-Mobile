import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/order/order_details_controller.dart';
import '../../utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';


class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  OrderDetailsScreen({super.key, required this.orderId});

  final OrderDetailsController c = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    // Fetch order details on screen open
    c.fetchOrderDetails(orderId);


    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header Section
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.13,
            decoration: BoxDecoration(
              color: AppColors.mainAppColor,
            ),
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 25.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    "assets/icons/backIcon.svg",
                    width: 24.w,
                    height: 24.h,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  "My Order Details",
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

          // Body Section
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade300,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20.h, width: 150.w, color: Colors.white),
                        SizedBox(height: 20.h),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        SizedBox(height: 20.h),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        SizedBox(height: 20.h),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        SizedBox(height: 20.h),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        SizedBox(height: 20.h),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        SizedBox(height: 20.h),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                        SizedBox(height: 20.h),
                        Container(height: 20.h, width: double.infinity, color: Colors.white),
                      ],
                    ),
                  ),
                );
              }

              if (c.errorMessage.isNotEmpty) {
                return Center(child: Text(c.errorMessage.value));
              }

              final data = c.orderDetails.value?.data;
              final totalServiceFee = data?.bags?.fold<int>(0, (previousValue, bag) => previousValue + (bag.serviceFee ?? 0),) ?? 0;


              if (data == null) {
                return const Center(child: Text("Order details not found"));
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "${data.fullName}",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3D3D3D),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                    Text(
                      "Phone",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      data.phone ?? 'Not given',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3D3D3D),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                    Text(
                      "Email",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      data.email ?? 'N/A',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3D3D3D),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),


                    Text(
                      "Order ID",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "${data.sId}",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3D3D3D),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),


                    Text(
                      "Pick-up Date And Time",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      _formatDate(data.pickupDate),
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3D3D3D),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),


                    Text(
                      "Drop-off Date and time",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      _formatDate(data.dropoffDate),
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3D3D3D),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                    Text(
                      "Address",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "${data.address}",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF3D3D3D),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "City",
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "${data.city}",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3D3D3D),
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "State",
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              data.state ?? "",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3D3D3D),
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ZIP",
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7C7C7C),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "${data.zipCode}",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF3D3D3D),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),

                    Divider(
                      thickness: 1.5,
                      color: Color(0xFFDCDCDC),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),


                    /// Price summary container
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFFC8CACC)),
                    ),
                    child: Column(
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Bag Name", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                            Text("Quantity", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                            Text("Price per bag", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Dynamic Bag List
                        Column(
                          children: data.bags!.map((bag) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(bag.bagsName ?? '', style: GoogleFonts.inter(fontSize: 14.sp)),
                                  Text("${bag.quantity}", style: GoogleFonts.inter(fontSize: 14.sp)),
                                  Text("${bag.pricePerBag}", style: GoogleFonts.inter(fontSize: 14.sp)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Service Fee", style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xFF101828),),),
                            Text("$totalServiceFee", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color(0xFF2B2B2B),),),
                          ],
                        ),

                        SizedBox(height: 10.h),
                        Divider(thickness: 1.5, color: Color(0xFFDCDCDC)),
                        SizedBox(height: 10.h),

                        // Total Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Payable", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                            Text("${data.totalPrice}", style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.030),
                    if (data.status?.toLowerCase() == "pending")
                      GestureDetector(
                        onTap: () async {
                          await c.cancelOrder(orderId);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: Colors.red, // You can make it red to indicate cancel
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel Order",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.080),

                  ],
                ),
              );
            }),
          ),

        ],
      ),
    );

  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "";
    final date = DateTime.tryParse(dateStr);
    if (date == null) return "";
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
