import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

Future<DateTime?> showCustomDatePickerSheet(
  BuildContext context, {
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? rangeStart, // when provided, highlights rangeStart..selected
}) async {
  return await showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return _DatePickerContent(
        initialDate: initialDate,
        // By default, do not allow past dates
        firstDate: _dateOnly(firstDate ?? DateTime.now()),
        lastDate: lastDate ?? DateTime.now().add(const Duration(days: 3650)),
        rangeStart: rangeStart != null ? _dateOnly(rangeStart) : null,
      );
    },
  );
}

DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

class _DatePickerContent extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? rangeStart;

  const _DatePickerContent({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.rangeStart,
  });

  @override
  State<_DatePickerContent> createState() => _DatePickerContentState();
}

class _DatePickerContentState extends State<_DatePickerContent> {
  late DateTime _visibleMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final DateTime firstDateOnly = _dateOnly(widget.firstDate);
    final DateTime initialOnly = _dateOnly(widget.initialDate);
    _selectedDate = initialOnly.isBefore(firstDateOnly) ? firstDateOnly : initialOnly;
    // Ensure visible month is not before firstDate's month
    final DateTime initMonth = DateTime(_selectedDate.year, _selectedDate.month);
    final DateTime minMonth = DateTime(firstDateOnly.year, firstDateOnly.month);
    _visibleMonth = _isMonthAfterOrEqual(initMonth, minMonth) ? initMonth : minMonth;
  }

  void _incrementMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta, 1);
    });
  }

  List<DateTime?> _daysForMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final firstWeekday = firstDayOfMonth.weekday % 7; // make Sunday = 0
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    final List<DateTime?> grid = List<DateTime?>.filled(firstWeekday, null, growable: true);
    for (int d = 1; d <= daysInMonth; d++) {
      grid.add(DateTime(month.year, month.month, d));
    }
    while (grid.length % 7 != 0) {
      grid.add(null);
    }
    return grid;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysForMonth(_visibleMonth);
    final DateTime firstDateOnly = _dateOnly(widget.firstDate);
    final bool canGoPrev = _isMonthAfter(DateTime(_visibleMonth.year, _visibleMonth.month), DateTime(firstDateOnly.year, firstDateOnly.month));

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                children: [
                  IconButton(
                    onPressed: canGoPrev ? () => _incrementMonth(-1) : null,
                    icon: Icon(
                      Icons.chevron_left,
                      color: canGoPrev ? AppColors.mainAppColor : const Color(0xFFBDBDBD),
                      size: 24.sp,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _monthYearString(_visibleMonth),
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mainAppColor,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _incrementMonth(1),
                    icon: Icon(Icons.chevron_right, color: AppColors.mainAppColor, size: 24.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _WeekdayLabel('SUN'),
                  _WeekdayLabel('MON'),
                  _WeekdayLabel('TUE'),
                  _WeekdayLabel('WED'),
                  _WeekdayLabel('THU'),
                  _WeekdayLabel('FRI'),
                  _WeekdayLabel('SAT'),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: days.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final day = days[index];
                  if (day == null) {
                    return const SizedBox.shrink();
                  }
                  final DateTime dayOnly = _dateOnly(day);
                  final bool isPast = dayOnly.isBefore(firstDateOnly);
                  final bool isSelected = !isPast && _isSameDay(dayOnly, _selectedDate);
                  final bool inRange = widget.rangeStart != null && !isPast
                      ? (dayOnly.isAfter(widget.rangeStart!) && dayOnly.isBefore(_selectedDate)) ||
                        _isSameDay(dayOnly, widget.rangeStart!) ||
                        _isSameDay(dayOnly, _selectedDate)
                      : false;
                  return GestureDetector(
                    onTap: isPast
                        ? null
                        : () {
                            setState(() {
                              _selectedDate = day;
                            });
                          },
                    child: Container(
                      decoration: inRange
                          ? BoxDecoration(
                              color: AppColors.mainAppColor.withOpacity(0.12),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: AppColors.mainAppColor.withOpacity(0.25)),
                            )
                          : BoxDecoration(
                              color: isSelected ? AppColors.mainAppColor : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(color: isSelected ? AppColors.mainAppColor : const Color(0xFFE5E5E5)),
                            ),
                      alignment: Alignment.center,
                      child: Text(
                        '${day.day}',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isPast
                              ? const Color(0xFFBDBDBD)
                              : (isSelected ? Colors.white : const Color(0xFF1F1D1D)),
                        ),
                      ),
                    ),
                  );
                },
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
                  onPressed: () => Navigator.of(context).pop(_selectedDate),
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

  String _monthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  static bool _isMonthAfter(DateTime aMonth, DateTime bMonth) {
    return (aMonth.year > bMonth.year) || (aMonth.year == bMonth.year && aMonth.month > bMonth.month);
  }

  static bool _isMonthAfterOrEqual(DateTime aMonth, DateTime bMonth) {
    return (aMonth.year > bMonth.year) || (aMonth.year == bMonth.year && aMonth.month >= bMonth.month);
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String text;
  const _WeekdayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF9E9E9E),
      ),
    );
  }
}


