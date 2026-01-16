import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OnboardingInfoPage extends StatelessWidget {
  const OnboardingInfoPage({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  final String imageAsset;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: Image.asset(
                imageAsset,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

