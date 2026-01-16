import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/onboarding/presentation/onboarding_cubit/onboarding_cubit.dart';
import 'package:car_rental_app/features/onboarding/presentation/widgets/onboarding_role_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingRoleSelectionPage extends StatelessWidget {
  const OnboardingRoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Text(
            'What\'s your goal?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 25),
          BlocBuilder<OnboardingCubit, OnboardingState>(
            buildWhen: (p, c) => p.userRole != c.userRole,
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OnboardingRoleOptionTile(
                    title: 'I want to rent a car',
                    icon: Icons.directions_car_filled,
                    isSelected: state.userRole == UserType.customer,
                    onTap: () => context.read<OnboardingCubit>().setUserRole(
                          UserType.customer,
                        ),
                  ),
                  const SizedBox(height: 12),
                  OnboardingRoleOptionTile(
                    title: 'I want to list my car',
                    icon: Icons.attach_money,
                    isSelected: state.userRole == UserType.seller,
                    onTap: () => context.read<OnboardingCubit>().setUserRole(
                          UserType.seller,
                        ),
                  ),
                ],
              );
            },
          ),
          // const Spacer(flex: 2),
        ],
      ),
    );
  }
}

