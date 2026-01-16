import 'package:car_rental_app/features/onboarding/presentation/widgets/onboarding_info_page.dart';
import 'package:flutter/material.dart';

class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingInfoPage(
      imageAsset: 'assets/onboarding/1.png',
      title: 'Rent cars easily, nearby.',
      subtitle:
          'Find trusted cars from people around you. Flexible prices, quick booking, no hassle.',
    );
  }
}

