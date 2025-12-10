import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/home/booking_controller.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String? selectedMethod;
  final BookingController bookingController = Get.find<BookingController>();

  @override
  void initState() {
    super.initState();
    // Initialize from booking controller if already selected
    if (bookingController.paymentMethod.value.isNotEmpty) {
      selectedMethod = bookingController.paymentMethod.value;
    }
  }

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
                    'Payment',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),

            // Progress Indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              color: Colors.white,
              child: Row(
                children: [
                  _buildProgressStep('Information', 1, isActive: true, isCompleted: true),
                  _buildProgressLine(true),
                  _buildProgressStep('date & time', 2, isActive: true, isCompleted: true),
                  _buildProgressLine(true),
                  _buildProgressStep('Payment', 3, isActive: false),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Summary:',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F1D1D),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    _buildSummaryCard(),

                    SizedBox(height: 24.h),

                    Text(
                      'Payment Method',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F1D1D),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    _buildPaymentOption(
                      title: 'Payment Stripe',
                      icon: Icons.credit_card,
                      value: 'stripe',
                    ),
                    SizedBox(height: 12.h),
                    _buildPaymentOption(
                      title: 'Hand Cash',
                      icon: Icons.payments_outlined,
                      value: 'cash',
                    ),

                    SizedBox(height: 24.h),

                    GestureDetector(
                      onTap: ()async{
                        if (selectedMethod == null) {
                          Get.snackbar('Error', 'Please select a payment method');
                          return;
                        }

                        // Save payment method
                        bookingController.paymentMethod.value = selectedMethod!;

                        // Handle based on payment method
                        if (selectedMethod == 'cash') {
                          // Submit booking for cash payment
                          final result = await bookingController.submitBooking();

                          if (result['success']) {
                            Navigator.of(context).pushNamed('/success_screen');
                          } else {
                            Get.snackbar('Booking Failed', result['message'] ?? 'Unknown error');
                          }
                        } else if (selectedMethod == 'stripe') {
                          Navigator.of(context).pushNamed(
                            '/stripe_payment_screen',
                            arguments: {
                              'bookingData': bookingController.prepareBookingData(),
                              'totalAmount': bookingController.getTotalPrice() + 2.00,
                            },
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: AppColors.mainAppColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            'Continue',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
      ),
    );
  }

  // Update booking summary
  Widget _buildSummaryCard() {
    final selectedBags = bookingController.selectedBags;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price per bag section
          if (selectedBags.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price per bag",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1D1D),
                  ),
                ),
                SizedBox(height: 15.h),
                ...selectedBags.entries.map((entry) {
                  final bag = entry.value;
                  return Padding(
                    padding:  EdgeInsets.only(bottom: 10.h),
                    child: _summaryRow(bag.name, '\$${bag.price}'),
                  );
                }).toList(),
              ],
            ),

          // Number of bag section
          if (selectedBags.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Number of bag",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F1D1D),
                  ),
                ),
                SizedBox(height: 15.h),
                ...selectedBags.entries.map((entry) {
                  final bag = entry.value;
                  return Padding(
                    padding:  EdgeInsets.only(bottom: 10.h),
                    child: _summaryRow(bag.name, '${bag.quantity}'),
                  );
                }).toList(),
              ],
            ),

          // Service fee (you can make this dynamic too if needed)
          SizedBox(height: 20.h),
          _summaryRow('Service fee', '\$2.00'),
          SizedBox(height: 20.h),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          SizedBox(height: 20.h),
          _summaryRow('Total Payable', '\$${bookingController.getTotalPrice() + 2.00}', isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF1F1D1D),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: const Color(0xFF1F1D1D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required String value,
  }) {
    final bool selected = selectedMethod == value;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.mainAppColor, size: 22.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1D1D),
                ),
              ),
            ),
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? AppColors.mainAppColor : const Color(0xFFBDBDBD), width: 2),
                color: Colors.white,
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.mainAppColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep(String label, int step, {bool isActive = false, bool isCompleted = false}) {
    Color circleColor = isActive ? AppColors.mainAppColor : const Color(0xFFE5E5E5);
    Color textColor = isActive ? AppColors.mainAppColor : (isCompleted ? const Color(0xFF1F1D1D) : const Color(0xFF757575));
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28.w,
            height: 28.h,
            decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$step',
                style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: isActive ? Colors.white : const Color(0xFF757575)),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 10.sp, fontWeight: FontWeight.w400, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        color: isActive ? AppColors.mainAppColor : const Color(0xFFE5E5E5),
      ),
    );
  }
}



