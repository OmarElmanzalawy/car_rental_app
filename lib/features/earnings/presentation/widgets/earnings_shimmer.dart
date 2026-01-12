import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EarningsShimmerCard extends StatelessWidget {
  const EarningsShimmerCard({
    super.key,
    required this.height,
    this.borderRadius = 18,
  });

  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
      ),
    );
  }
}

class EarningsShimmerListTile extends StatelessWidget {
  const EarningsShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const EarningsShimmerCard(height: 72, borderRadius: 16);
  }
}

