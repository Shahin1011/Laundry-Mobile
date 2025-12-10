import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../components/custom_date_picker_sheet.dart';
import '../components/custom_time_picker_sheet.dart';
import '../../utils/app_colors.dart';
import 'package:get/get.dart';
import '../../controller/home/booking_controller.dart';



class DateTimeScreen extends StatefulWidget {
  const DateTimeScreen({super.key});

  @override
  State<DateTimeScreen> createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {

  final BookingController bookingController = Get.find<BookingController>();

  DateTime? pickUpDate;
  TimeOfDay? pickUpTime;
  DateTime? dropOffDate;
  TimeOfDay? dropOffTime;

  // Set default values
  @override
  void initState() {
    super.initState();
    pickUpDate = null; // no default date
    pickUpTime = null; // no default time
    dropOffDate = null; // no default date
    dropOffTime = null; // no default time
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
                    'Date & Time',
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
                  _buildProgressLine(isActive: true),
                  _buildProgressStep('date & time', 2, isActive: true),
                  _buildProgressLine(isActive: false),
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
                    // Pick-up Date and Time Section
                    Text(
                      'Pick-up Date And Time',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1D1D),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    // Pick-up Date
                    _buildDateField(
                      label: 'Date',
                      date: pickUpDate,
                      placeholder: 'Select Pick-up Date',
                      onTap: () async {
                        final DateTime? picked = await showCustomDatePickerSheet(
                          context,
                          initialDate: pickUpDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != pickUpDate) {
                          setState(() {
                            pickUpDate = picked;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 12.h),
                    
                    // Pick-up Time
                    _buildTimeField(
                      label: 'Time',
                      time: pickUpTime,
                      placeholder: 'Select Pick-up Time',
                      onTap: () async {
                        final TimeOfDay? picked = await showCustomTimePickerSheet(
                          context,
                          initialTime: pickUpTime ?? TimeOfDay.now(),
                        );
                        if (picked != null && picked != pickUpTime) {
                          setState(() {
                            pickUpTime = picked;
                          });
                        }
                      },
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Drop-off Date and Time Section
                    Text(
                      'Drop-off Date and time',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F1D1D),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    // Drop-off Date
                    _buildDateField(
                      label: 'Date',
                      date: dropOffDate,
                      placeholder: 'Select Drop-off Date',
                      onTap: () async {
                        final DateTime? picked = await showCustomDatePickerSheet(
                          context,
                          initialDate: dropOffDate ?? DateTime.now(),
                          firstDate: (pickUpDate ?? DateTime.now()),
                          lastDate: DateTime(2030),
                          rangeStart: pickUpDate,
                        );
                        if (picked != null && picked != dropOffDate) {
                          setState(() {
                            dropOffDate = picked;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 12.h),
                    
                    // Drop-off Time
                    _buildTimeField(
                      label: 'Time',
                      time: dropOffTime,
                      placeholder: 'Select Drop-off Time',
                      onTap: () async {
                        final TimeOfDay? picked = await showCustomTimePickerSheet(
                          context,
                          initialTime: dropOffTime ?? TimeOfDay.now(),
                        );
                        if (picked != null && picked != dropOffTime) {
                          setState(() {
                            dropOffTime = picked;
                          });
                        }
                      },
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Continue Button
                    GestureDetector(
                      onTap: () {
                        // Validate date and time
                        if (pickUpDate == null) {
                          Get.snackbar('Error', 'Please select pick-up date');
                          return;
                        }
                        if (pickUpTime == null) {
                          Get.snackbar('Error', 'Please select pick-up time');
                          return;
                        }
                        if (dropOffDate == null) {
                          Get.snackbar('Error', 'Please select drop-off date');
                          return;
                        }
                        if (dropOffTime == null) {
                          Get.snackbar('Error', 'Please select drop-off time');
                          return;
                        }

                        // Save to booking controller
                        bookingController.pickupDate.value = pickUpDate;
                        bookingController.pickupTime.value = pickUpTime;
                        bookingController.dropoffDate.value = dropOffDate;
                        bookingController.dropoffTime.value = dropOffTime;

                        // Navigate to payment screen
                        Navigator.of(context).pushNamed('/payment_screen');
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
                    
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildProgressStep(String label, int step, {required bool isActive, bool isCompleted = false}) {
    Color circleColor = isActive ? AppColors.mainAppColor : Color(0xFFE5E5E5);
    Color textColor = isActive ? AppColors.mainAppColor : (isCompleted ? Color(0xFF1F1D1D) : Color(0xFF757575));
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 28.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Color(0xFF757575),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressLine({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 2.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        color: isActive ? AppColors.mainAppColor : Color(0xFFE5E5E5),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    String? placeholder,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null ? DateFormat('dd MMM yyyy').format(date) : (placeholder ?? ''),
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: date != null ? Color(0xFF1F1D1D) : Color(0xFF757575),
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 20.sp,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
    String? placeholder,
  }) {
    String formatTimeOfDay(TimeOfDay tod) {
      final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
      final minute = tod.minute.toString().padLeft(2, '0');
      final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Color(0xFFE5E5E5),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time != null ? formatTimeOfDay(time) : (placeholder ?? ''),
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: time != null ? Color(0xFF1F1D1D) : Color(0xFF757575),
              ),
            ),
            Icon(
              Icons.access_time,
              size: 20.sp,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }

}

