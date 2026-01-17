import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/core/widgets/custom_textfield.dart';
import 'package:car_rental_app/features/home/Presentation/customer/blocs/cars_bloc/cars_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExtendedCarFilterSheet extends StatelessWidget {
  const ExtendedCarFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final maxHeight = size.height * 0.78;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
        margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.tune,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Filter",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "All Brands",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: const [
                          _BrandChip(label: "BMW"),
                          _BrandChip(label: "Nissan"),
                          _BrandChip(label: "Mazda", isSelected: true),
                          _BrandChip(label: "Honda"),
                          _BrandChip(label: "Tesla"),
                          _BrandChip(label: "Audi"),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Text(
                            "Radius",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Search radius (250m)",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Slider.adaptive(
                        value: 0.5,
                        onChanged: (value){},
                        min: 0.0,
                        max: 1.0,
                        ),
                      const SizedBox(height: 18),
                      const Text(
                        "Price (\$)",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              child: CustomTextfield(
                                hintText: "Minimum",
                                keyboardType: TextInputType.number,
                                isFilled: true,
                                
                                fillColor: AppColors.surface,
                                borderColor: AppColors.border,
                                focusColor: AppColors.primary,
                                textColor: Colors.black,
                                hintColor: AppColors.textSecondary,
                                borderRadius: 12,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: CustomTextfield(
                                hintText: "Maximum",
                                keyboardType: TextInputType.number,
                                isFilled: true,
                                fillColor: AppColors.surface,
                                borderColor: AppColors.border,
                                focusColor: AppColors.primary,
                                textColor: Colors.black,
                                hintColor: AppColors.textSecondary,
                                borderRadius: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Other Preferences",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Transmission type"),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: AdaptivePopupMenuButton.text(
                                label: '4',
                                items: GearBox.values.map((e) => AdaptivePopupMenuItem(
                                  label: AppUtils.capitalize(e.name),
                                  value: e,
                                )).toList(),
                                // items: [
                                //   AdaptivePopupMenuItem(
                                //     label: '2',
                                //     value: 2,
                                //   ),
                                //   AdaptivePopupMenuItem(
                                //     label: '4',
                                //     value: 4,
                                //   ),
                                //   AdaptivePopupMenuItem(
                                //     label: '5',
                                //     value: 5,
                                //   ),
                                //    AdaptivePopupMenuItem(
                                //     label: '6',
                                //     value: 6,
                                //   ),
                                // ],
                                onSelected: (index, item) {
                                  print('Selected: ${item.value}');
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  // isLiquidGlass: true,
                  label: "Apply Filter",
                  onPressed: () {
                    print("apply filter");
                    context.read<CarsBloc>().add(ApplyFilterEvent());
                    context.pop();
                  },
                  liquidGlassSize: AdaptiveButtonSize.large,
                  liquidGlasMinimumSize: const Size(200, 52),
                  useSmoothRectangleBorder: false,
                  liquidGlassStyle: AdaptiveButtonStyle.prominentGlass,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandChip extends StatelessWidget {
  const _BrandChip({required this.label, this.isSelected = false});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/logos/${label.toLowerCase()}.png",
            height: 16,
            width: 16,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(height: 16, width: 16);
            },
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
