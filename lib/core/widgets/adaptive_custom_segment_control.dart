import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class AdaptiveCustomSegmentControl extends StatelessWidget {

  final List<String> labels;
  final int selectedIndex;
  final Function(int) onValueChanged;

  const AdaptiveCustomSegmentControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PlatformWidget(
      material: (context, platform) {
        return  Container(
                  width: size.width,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    runSpacing: 12,
                    children: List.generate(
                      labels.length,
                      (index) => _SegmentChip(
                        index: index,
                        onValueChanged: onValueChanged,
                        label: labels[index],
                        selected: selectedIndex == index,
                      ),
                    ),
                  ),
                );
      },
      cupertino: (context, platform) {
        return AdaptiveSegmentedControl(
          labels: labels,
          selectedIndex: selectedIndex,
          onValueChanged: onValueChanged
        );
      },
    );
  }
}


class _SegmentChip extends StatelessWidget {
  const _SegmentChip({
    required this.index,
    required this.label,
    this.selected = false,
    required this.onValueChanged,
  });
  final int index;
  final String label;
  final bool selected;
  final Function(int) onValueChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onValueChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? AppColors.background : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primary : Colors.black,
          ),
        ),
      ),
    );
  }
}
