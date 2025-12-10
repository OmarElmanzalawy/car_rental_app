import 'dart:math' as math;
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/home/Presentation/blocs/date_picker_bloc/date_picker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatePickerGrid extends StatelessWidget {
  const DatePickerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatePickerBloc, DatePickerState>(
      builder: (context, state) {
        final currentMonth = state.months[state.monthIndex];
        final days = AppUtils.first30DaysOfMonth(currentMonth);
        final start = state.startDate;
        final end = state.endDate;
        final direction = state.slideDirection;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppUtils.monthYearLabel(currentMonth),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    RoundIconButton(
                      icon: Icons.chevron_left,
                      onPressed: (){
                        context.read<DatePickerBloc>().add(PreviousMonthEvent());
                      },
                    ),
                    const SizedBox(width: 10),
                    RoundIconButton(
                      icon: Icons.chevron_right,
                      onPressed: (){
                        context.read<DatePickerBloc>().add(NextMonthEvent());
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.bounceOut,
              switchOutCurve: Curves.bounceOut,
              transitionBuilder: (child, animation) {
                final beginOffset = Offset(direction > 0 ? 1 : -1, 0);
                final tween = Tween<Offset>(begin: beginOffset, end: Offset.zero);
                return ClipRect(
                  child: SlideTransition(
                    position: tween.animate(animation),
                    child: child,
                  ),
                );
              },
              child: LayoutBuilder(
                key: ValueKey("month-grid-${state.monthIndex}"),
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final estimated = (width / 72).floor();
                  final columns = math.max(4, math.min(7, estimated));
                  final now = AppUtils.currentDate();
                  final todayDate = DateTime(now.year, now.month, now.day);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: days.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final d = days[index];
                      bool isSelected = false;
                      if (start != null && end != null) {
                        isSelected = !d.isBefore(start) && !d.isAfter(end);
                      } else if (start != null) {
                        isSelected = d.year == start.year && d.month == start.month && d.day == start.day;
                      }
                      final isDisabled = d.isBefore(todayDate);
                      return GestureDetector(
                        onTap: isDisabled ? null : () {
                          context.read<DatePickerBloc>().add(SelectDateEvent(selectedDate: d));
                        },
                        child: DateChip(
                          dayLabel: AppUtils.shortWeekday(d),
                          date: d.day,
                          selected: isSelected,
                          disabled: isDisabled,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({required this.icon, this.onPressed, super.key});
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AdaptiveButton.icon(
      iconColor: Colors.black87,
      style: AdaptiveButtonStyle.prominentGlass,
      minSize: const Size(36, 36),
      color: Colors.grey.shade200,
      onPressed: onPressed ?? () {},
      icon: icon,
    );
  }
}

class DateChip extends StatelessWidget {
  const DateChip({
    super.key,
    required this.dayLabel,
    required this.date,
    this.selected = false,
    this.disabled = false,
  });
  final String dayLabel;
  final int date;
  final bool selected;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final Color bg = disabled
        ? AppColors.border
        : (selected ? AppColors.primary : AppColors.silverAccent.withOpacity(0.5));
    final Color dayColor = disabled
        ? Colors.grey.shade400
        : (selected ? Colors.white : Colors.grey.shade700);
    final Color dateColor = disabled
        ? Colors.grey.shade400
        : (selected ? Colors.white : Colors.black);
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayLabel,
            style: TextStyle(
              fontSize: 12,
              color: dayColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: dateColor,
            ),
          ),
        ],
      ),
    );
  }
}
