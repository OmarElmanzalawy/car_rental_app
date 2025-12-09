import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/home/Presentation/blocs/date_picker_bloc/date_picker_bloc.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import 'package:car_rental_app/features/home/Presentation/widgets/date_picker_grid.dart';

class CarDetailScreen extends StatelessWidget {
  const CarDetailScreen({super.key,required this.model});

  final CarModel model;

  @override
  Widget build(BuildContext context) {
    final bool isImageTransparent = model.images!.first.endsWith(".png");
    final Size size = MediaQuery.sizeOf(context);
    return AdaptiveScaffold(
      enableBlur: false,
      appBar: AdaptiveAppBar(
        title: isImageTransparent ? "\tCar details\t" : null,
        useNativeToolbar: true,
        actions: [
          AdaptiveAppBarAction(
            icon: Icons.favorite_border,
            iosSymbol: "heart",
            spacerAfter: ToolbarSpacerType.none,
            onPressed: () {},
          ),
          AdaptiveAppBarAction(
            iosSymbol: "info.circle.fill",
            icon: Icons.access_alarm,
            spacerAfter: ToolbarSpacerType.none,
            onPressed: () {},
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => DatePickerBloc()..add(SelectDateEvent(selectedDate: AppUtils.currentDate())),
        child: SafeArea(
          top: isImageTransparent ? true : false,
          bottom: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height:  isImageTransparent ? 40 : 0),
                    SizedBox(
                      // height: size.height * 0.27,
                      child: Center(
                        child: Image.asset(
                          "assets/images/test_cars/${model.images!.first}",
                          fit: isImageTransparent ? BoxFit.cover : BoxFit.cover,
                          width: isImageTransparent ? size.width * 0.9 : size.width,
                          height: isImageTransparent ? size.height * 0.26 : size.height * 0.38,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  model.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "${model.rating}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Overview",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${model.description}........ Read More",
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Features",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              spacing: 8,
                              children: [
                                _DetailTile(
                                  icon: Icons.speed,
                                  label: "Max Speed",
                                  value: "${model.maxSpeed} Km/h",
                                ),
                                _DetailTile(
                                  icon: Icons.airline_seat_recline_normal,
                                  label: "Ability",
                                  value: "${model.seats} Seats",
                                ),
                                _DetailTile(
                                  icon: Icons.car_repair,
                                  label: "Gearbox",
                                  value: "${model.gearbox.name}",
                                ),
                              ],
                            ),
                            const SizedBox(height: 8,),
                             Row(
                              spacing: 8,
                              children: [
                                _DetailTile(
                                  icon: switch (model.fuelType) {
                                    FuelType.electric => Icons.electric_bolt_outlined,
                                    FuelType.petrol => Icons.local_gas_station_outlined,
                                    FuelType.naturalGas => Icons.propane_tank_outlined,
                                    FuelType.hybrid => Icons.tonality_outlined
                                  },
                                  label: "Fuel Type",
                                  value: "${AppUtils.capitalize(model.fuelType.name)}",

                                ),
                                // _DetailTile(
                                //   icon: Icons.airline_seat_recline_normal,
                                //   label: "Ability",
                                //   value: "${model.seats} Seats",
                                // ),
                                // _DetailTile(
                                //   icon: Icons.car_repair,
                                //   label: "Gearbox",
                                //   value: "${model.gearbox.name}",
                                // ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const DatePickerGrid(),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 25,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: const TextSpan(
                            text: "\$340",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: "/day",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        // height: 48,
                        // width: 50,
                        child: AdaptiveButton(
                          textColor: Colors.white,
                          style: AdaptiveButtonStyle.filled,
                          minSize: Size(140, 40),
                          size: AdaptiveButtonSize.large,
                          onPressed: () {
                            context.push(AppRoutes.bookRentalCar);
                          },
                          label: "Book Now",
                          borderRadius: BorderRadius.circular(25),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    this.isDense = false,
  });
  final IconData icon;
  final String label;
  final String value;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                // height: 100,
                // width: 120,
                height: size.height * 0.11,
                width: size.width * 0.28,
                decoration: BoxDecoration(
                  color: AppColors.silverAccent.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.grey.shade700),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, this.onPressed});
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: 36,
    //   height: 36,
    //   decoration: BoxDecoration(
    //     color: AppColors.surface,
    //     shape: BoxShape.circle,
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.05),
    //         blurRadius: 10,
    //         offset: const Offset(0, 4),
    //       ),
    //     ],
    //   ),
    //   child: Icon(icon, color: Colors.black),
    // );
    return AdaptiveButton.icon(
      iconColor: Colors.black87,
      style: AdaptiveButtonStyle.prominentGlass,
      minSize: Size(36, 36),
      color: Colors.grey.shade200,
      onPressed: onPressed ?? () {},
      icon: icon,
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.dayLabel,
    required this.date,
    this.selected = false,
    this.disabled = false,
  });
  final String dayLabel;
  final int date;
  final bool selected;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final Color bg = disabled
        ? AppColors.border
        : (selected ? AppColors.primary : AppColors.silverAccent.withOpacity(0.5));
    final Color dayColor = disabled
        ? Colors.grey.shade400
        : (selected ? Colors.white : Colors.grey.shade700);
    final Color dateColor = disabled
        ? Colors.grey.shade400
        : (selected ? Colors.white : Colors.black);
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayLabel,
            style: TextStyle(
              fontSize: 12,
              color: dayColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: dateColor,
            ),
          ),
        ],
      ),
    );
  }
}
