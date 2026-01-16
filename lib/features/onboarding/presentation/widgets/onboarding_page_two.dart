import 'package:car_rental_app/features/onboarding/presentation/widgets/onboarding_info_page.dart';
import 'package:flutter/material.dart';

class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingInfoPage(
      imageAsset: 'assets/onboarding/2.jpg',
      title: 'Built on trust and safety',
      subtitle:
          'Verified users, real reviews, and secure in-app payments for peace of mind.',
    );
  }
}

