import 'package:car_rental_app/features/onboarding/presentation/widgets/onboarding_info_page.dart';
import 'package:flutter/material.dart';

class OnboardingPageThree extends StatelessWidget {
  const OnboardingPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingInfoPage(
      imageAsset: 'assets/onboarding/3.jpg',
      title: 'Rent or earn — your choice',
      subtitle:
          'Book a car when you need one, or earn money by listing your own.',
    );
  }
}

