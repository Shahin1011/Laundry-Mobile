import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controller/home/choice_package_controller.dart';
import '../../controller/home/booking_controller.dart'; // Add this import
import '../../utils/app_colors.dart';
import '../../helpers/route.dart';

class ChoicePackageScreen extends StatelessWidget {
  ChoicePackageScreen({super.key});

  final ChoicePackageController c = Get.find<ChoicePackageController>();
  final BookingController bookingController = Get.find<BookingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Header
          Container(
            height: MediaQuery.of(context).size.height * 0.13,
            color: AppColors.mainAppColor,
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 25.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    "assets/icons/backIcon.svg",
                    width: 24.w,
                    height: 24.h,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  'Choice Package',
                  style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                SizedBox(),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (c.errorMessage.isNotEmpty) {
                return Center(child: Text(c.errorMessage.value));
              }

              if (c.packages.isEmpty) {
                return const Center(child: Text("No packages available"));
              }

              final package = c.packages[0];
              final pkg = package.bagCategory;

              final List<BagOption> allBags = [];

              if (pkg?.small != null && pkg!.small!.isNotEmpty) {
                for (var b in pkg.small!) {
                  allBags.add(BagOption(
                    name: "Small",
                    id: b.id ?? '',
                    weight: "${b.kg ?? ''} kg",
                    price: b.price ?? 0,
                    serviceFee: b.serviceFee ?? 0,
                    description: b.description ?? '',
                  ));
                }
              }

              if (pkg?.medium != null && pkg!.medium!.isNotEmpty) {
                for (var b in pkg.medium!) {
                  allBags.add(BagOption(
                    name: "Medium",
                    id: b.id ?? '',
                    weight: "${b.kg ?? ''} kg",
                    price: b.price ?? 0,
                    serviceFee: b.serviceFee ?? 0,
                    description: b.description ?? '',
                  ));
                }
              }

              if (pkg?.large != null && pkg!.large!.isNotEmpty) {
                for (var b in pkg.large!) {
                  allBags.add(BagOption(
                    name: "Large",
                    id: b.id ?? '',
                    weight: "${b.kg ?? ''} kg",
                    price: b.price ?? 0,
                    serviceFee: b.serviceFee ?? 0,
                    description: b.description ?? '',
                  ));
                }
              }

              return Column(
                children: [
                  // Selected bags summary
                  Obx(() {
                    if (bookingController.selectedBags.isEmpty) {
                      return SizedBox.shrink();
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.mainAppColor.withOpacity(0.1),
                        border: Border(
                          bottom: BorderSide(color: AppColors.mainAppColor.withOpacity(0.2)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${bookingController.selectedBags.length} type${bookingController.selectedBags.length > 1 ? 's' : ''} of bag${bookingController.selectedBags.length > 1 ? 's' : ''} selected',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainAppColor,
                                ),
                              ),
                              Text(
                                'Total: \$${bookingController.getTotalPrice().toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              bookingController.clearAllBags();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: AppColors.mainAppColor,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'Clear All',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  // Bag list
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              'Choose Your Bags',
                              style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333)),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          ...allBags.map((bag) => _buildBagItem(context, bag)),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // Continue Button (sticky at bottom)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      //border: Border(top: BorderSide(color: Color(0xFFE5E5E5))),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (c.validateSelection()) {
                          Get.toNamed(
                            AppRoutes.informationScreen,
                          );
                        }
                      },
                      child: Obx(() {
                        final totalBags = bookingController.getTotalBags();

                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            color: bookingController.selectedBags.isNotEmpty
                                ? AppColors.mainAppColor
                                : Color(0xFFE5E5E5),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  bookingController.selectedBags.isEmpty
                                      ? 'Select bags to continue'
                                      : 'Continue with $totalBags bag${totalBags > 1 ? 's' : ''}',
                                  style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: bookingController.selectedBags.isNotEmpty
                                          ? Colors.white
                                          : Color(0xFF999999)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.060)
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBagItem(BuildContext context, BagOption bag) {
    return Obx(() {
      final isSelected = bookingController.selectedBags.containsKey(bag.id);
      final bagSelection = bookingController.selectedBags[bag.id];
      final quantity = bagSelection?.quantity ?? 1;

      return GestureDetector(
        onTap: () {
          if (isSelected) {
            bookingController.removeBag(bag.id);
          } else {
            bookingController.addBagSelection(
              bag.id,
              bag.name,
              bag.weight,
              bag.price,
              bag.serviceFee,
              1,
            );
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColors.mainAppColor : Color(0xFFE5E5E5),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Bag Image
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F4F6),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Image.asset('assets/images/bag.png', fit: BoxFit.contain),
                  ),
                  SizedBox(width: 16.w),

                  // Bag Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bag.name,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F1D1D),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          bag.weight,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quantity Selector (only show when selected)
                  if (isSelected)
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE5E5E5)),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (quantity > 1) {
                                bookingController.updateBagQuantity(bag.id, quantity - 1);
                              } else {
                                bookingController.removeBag(bag.id);
                              }
                            },
                            child: Container(
                              width: 36.w,
                              height: 36.h,
                              alignment: Alignment.center,
                              child: Icon(Icons.remove,
                                  size: 18.sp,
                                  color: quantity > 1
                                      ? Color(0xFF1F1D1D)
                                      : Color(0xFFC8CACC)),
                            ),
                          ),
                          Container(
                            width: 40.w,
                            alignment: Alignment.center,
                            child: Text('$quantity',
                                style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1F1D1D))),
                          ),
                          GestureDetector(
                            onTap: () => bookingController.updateBagQuantity(bag.id, quantity + 1),
                            child: Container(
                              width: 36.w,
                              height: 36.h,
                              alignment: Alignment.center,
                              child: Icon(Icons.add, size: 18.sp, color: Color(0xFF1F1D1D)),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(width: isSelected ? 16.w : 0),

                  Text(
                    '\$${bag.price.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F1D1D),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 10.h),

              // Service Fee & Total on the right
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Service fee: \$${bag.serviceFee.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF757575),
                      ),
                    ),
                    if (isSelected)
                      Text(
                        'Total: \$${(bag.price * quantity + bag.serviceFee).toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainAppColor,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              Text(
                bag.description,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF757575),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),


            ],
          ),
        ),
      );
    });
  }
}