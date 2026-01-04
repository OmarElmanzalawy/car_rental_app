import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SellerCalendarStrip extends StatelessWidget {
  const SellerCalendarStrip({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.onChanged,
  });

  final List<DateTime> dates;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: Row(
        children: List.generate(
          dates.length,
          (index) {
            final date = dates[index];
            final selected = selectedDate != null && _isSameDay(date, selectedDate!);
            return Padding(
              padding: EdgeInsets.only(right: index == dates.length - 1 ? 0 : 10),
              child: GestureDetector(
                onTap: () => onChanged(date),
                child: Container(
                  width: 54,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weekdayShort(date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: selected ? Colors.white : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekdayShort(DateTime dt) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[(dt.weekday - 1).clamp(0, 6)];
  }
}
