import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ReviewStar extends StatelessWidget {
  const ReviewStar({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isActive = value >= starValue;

        return IconButton(
          onPressed: () => onChanged(starValue),
          iconSize: 50,
          splashRadius: 22,
          icon: Icon(
            isActive ? Icons.star_rounded : Icons.star_outline_rounded,
            color: isActive ? AppColors.primary : Colors.grey.shade400,
          ),
        );
      }),
    );
  }
}