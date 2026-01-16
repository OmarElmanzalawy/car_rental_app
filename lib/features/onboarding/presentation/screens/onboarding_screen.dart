import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/features/onboarding/presentation/onboarding_cubit/onboarding_cubit.dart';
import 'package:car_rental_app/features/onboarding/presentation/widgets/onboarding_page_one.dart';
import 'package:car_rental_app/features/onboarding/presentation/widgets/onboarding_page_three.dart';
import 'package:car_rental_app/features/onboarding/presentation/widgets/onboarding_page_two.dart';
import 'package:car_rental_app/features/onboarding/presentation/widgets/onboarding_role_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  static const int _pageCount = 4;
  static const int _roleSelectionIndex = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int index) async {
    if (!_pageController.hasClients) return;
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: AdaptiveScaffold(
        body: Material(
          color: AppColors.background,
          child: SafeArea(
            child: BlocBuilder<OnboardingCubit, OnboardingState>(
              buildWhen: (p, c) =>
                  p.currentPage != c.currentPage || p.userRole != c.userRole,
              builder: (context, state) {
                final isRoleSelection = state.currentPage == _roleSelectionIndex;
                final canContinue = !isRoleSelection || state.userRole != null;

                final primaryLabel = isRoleSelection
                    ? 'Continue'
                    : (state.currentPage == 0 ? 'Get Started' : 'Next');

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _pageCount,
                        effect: ScrollingDotsEffect(
                          activeDotScale: 1.3,
                          smallDotScale: 0.5,
                          spacing: 30,
                          radius: 999,
                          dotHeight: 20,
                          dotWidth: 20,
                          // dotColor: Colors.blue.shade100,
                          activeDotColor: AppColors.primary,
                        ),
                        onDotClicked: (index) => _goToPage(index),
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            context.read<OnboardingCubit>().setCurrentPage(index);
                          },
                          children: const [
                            OnboardingPageOne(),
                            OnboardingPageTwo(),
                            OnboardingPageThree(),
                            OnboardingRoleSelectionPage(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ActionButton(
                          isLiquidGlass: true,
                          liquidGlasMinimumSize: const Size(200, 48),
                          label: primaryLabel,
                          backgroundColor:
                              canContinue ? AppColors.primary : AppColors.silverAccent,
                          foregroundColor:
                              canContinue ? Colors.white : AppColors.textSecondary,
                          onPressed: () async {
                            if (!canContinue) {
                              DialogueService.showAdaptiveSnackBar(
                                context,
                                message: 'Please choose an option to continue.',
                                type: AdaptiveSnackBarType.error,
                              );
                              return;
                            }

                            if (!isRoleSelection) {
                              await _goToPage(
                                (state.currentPage + 1).clamp(0, _pageCount - 1),
                              );
                              return;
                            }

                            context.go(AppRoutes.signup, extra: state.userRole);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
