import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

Future<TimeOfDay?> showCustomTimePickerSheet(
  BuildContext context, {
  required TimeOfDay initialTime,
}) async {
  return await showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return _TimePickerContent(initialTime: initialTime);
    },
  );
}

class _TimePickerContent extends StatefulWidget {
  final TimeOfDay initialTime;
  const _TimePickerContent({required this.initialTime});

  @override
  State<_TimePickerContent> createState() => _TimePickerContentState();
}

class _TimePickerContentState extends State<_TimePickerContent> {
  late int _hour; // 1-12
  late int _minute; // 0-59
  late bool _isAm; // true AM, false PM

  @override
  void initState() {
    super.initState();
    _isAm = widget.initialTime.period == DayPeriod.am;
    int h = widget.initialTime.hourOfPeriod;
    _hour = h == 0 ? 12 : h;
    _minute = widget.initialTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPicker(
                    label: 'Hour',
                    itemCount: 12,
                    initialIndex: _hour - 1,
                    selectedIndex: _hour - 1,
                    itemBuilder: (i) => (i + 1).toString().padLeft(2, '0'),
                    onSelected: (i) => setState(() => _hour = i + 1),
                  ),
                  _buildPicker(
                    label: 'Min',
                    itemCount: 60,
                    initialIndex: _minute,
                    selectedIndex: _minute,
                    itemBuilder: (i) => i.toString().padLeft(2, '0'),
                    onSelected: (i) => setState(() => _minute = i),
                  ),
                  _buildAmPm(),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainAppColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  onPressed: () {
                    final int hour24 = (_hour % 12) + (_isAm ? 0 : 12);
                    Navigator.of(context).pop(TimeOfDay(hour: hour24, minute: _minute));
                  },
                  child: Text(
                    'Select',
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
    );
  }

  Widget _buildPicker({
    required String label,
    required int itemCount,
    required int initialIndex,
    required int selectedIndex,
    required String Function(int) itemBuilder,
    required void Function(int) onSelected,
  }) {
    final controller = FixedExtentScrollController(initialItem: initialIndex);
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12.sp, color: const Color(0xFF9E9E9E))),
        SizedBox(
          width: 90.w,
          height: 160.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Wheel
              ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: 36.h,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: onSelected,
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    if (index < 0 || index >= itemCount) return null;
                    final bool isSelected = index == selectedIndex;
                    return Center(
                      child: Text(
                        itemBuilder(index),
                        style: GoogleFonts.inter(
                          fontSize: isSelected ? 20.sp : 16.sp,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.mainAppColor : const Color(0xFF1F1D1D).withOpacity(0.6),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Selection highlight
              IgnorePointer(
                child: Container(
                  width: double.infinity,
                  height: 36.h,
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    color: AppColors.mainAppColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.mainAppColor, width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmPm() {
    return Column(
      children: [
        Text('AM/PM', style: GoogleFonts.inter(fontSize: 12.sp, color: const Color(0xFF9E9E9E))),
        SizedBox(height: 8.h),
        ToggleButtons(
          isSelected: [_isAm, !_isAm],
          borderRadius: BorderRadius.circular(8.r),
          selectedColor: Colors.white,
          color: const Color(0xFF1F1D1D),
          fillColor: AppColors.mainAppColor,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text('AM', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text('PM', style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            ),
          ],
          onPressed: (i) => setState(() => _isAm = i == 0),
        ),
      ],
    );
  }
}


