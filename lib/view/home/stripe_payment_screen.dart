import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_colors.dart';
import '../../utils/app_contants.dart';
import '../../utils/token_service.dart';
import '../../helpers/route.dart';
import '../../services/payment_service.dart';
import '../../controller/home/booking_controller.dart';

class StripePaymentScreen extends StatefulWidget {
  const StripePaymentScreen({super.key});

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  final BookingController _bookingController = Get.find<BookingController>();
  
  bool _isProcessing = false;
  bool _isCreatingOrder = false;
  String? _errorMessage;
  String? _orderId;
  double? _totalAmount;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _totalAmount = args['totalAmount'] as double?;
    }
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Step 1: Create order first
      if (_orderId == null) {
        setState(() {
          _isCreatingOrder = true;
        });

        final bookingResult = await _bookingController.submitBooking(forStripePayment: true);
        
        setState(() {
          _isCreatingOrder = false;
        });

        if (!bookingResult['success']) {
          String errorMsg = bookingResult['message'] ?? 'Failed to create order';
          
          setState(() {
            _errorMessage = errorMsg;
            _isProcessing = false;
          });
          return;
        }

        // Extract order ID from response
        final orderData = bookingResult['data'];
        if (orderData != null && orderData['data'] != null) {
          _orderId = orderData['data']['_id'] as String?;
        } else if (orderData != null && orderData['_id'] != null) {
          _orderId = orderData['_id'] as String?;
        }

        if (_orderId == null) {
          setState(() {
            _errorMessage = 'Failed to get order ID';
            _isProcessing = false;
          });
          return;
        }
      }

      // Step 2: Process payment
      final result = await _paymentService.processPayment(orderId: _orderId!);

      setState(() {
        _isProcessing = false;
      });

      if (result.success) {
        // Payment successful
        Get.offNamed(AppRoutes.successScreen);
      } else {
        // Payment failed
        setState(() {
          _errorMessage = result.message;
        });
        Get.snackbar(
          'Payment Failed',
          result.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _isCreatingOrder = false;
        _errorMessage = e.toString();
      });
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
                  'Stripe Payment',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(),
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
                  // Payment Summary
                  _buildPaymentSummary(),

                  SizedBox(height: 24.h),

                  // Error Message
                  if (_errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 16.h),

                  // Payment Info
                  _buildPaymentInfo(),

                  SizedBox(height: 24.h),

                  // Pay Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainAppColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      onPressed: (_isProcessing || _isCreatingOrder) ? null : _processPayment,
                      child: (_isProcessing || _isCreatingOrder)
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Pay Now',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Security Note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 8.w),
                      Text(
                        'Your payment is secured by Stripe',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
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
          Text(
            'Payment Summary',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F1D1D),
            ),
          ),
          SizedBox(height: 16.h),
          if (_totalAmount != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1F1D1D),
                  ),
                ),
                Text(
                  '\$${_totalAmount!.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mainAppColor,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo() {
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
          Row(
            children: [
              Icon(Icons.info_outline, size: 20.sp, color: AppColors.mainAppColor),
              SizedBox(width: 8.w),
              Text(
                'Payment Information',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F1D1D),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Click "Pay Now" to securely enter your card details using Stripe\'s payment sheet. Your card information is never stored on our servers.',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFF757575),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}


