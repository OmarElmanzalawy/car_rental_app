import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/bookings/presentation/blocs/date_picker_bloc/date_picker_bloc.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:car_rental_app/features/bookings/presentation/widgets/date_picker_grid.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarDetailScreen extends StatelessWidget {
  CarDetailScreen({super.key,required this.model});

  final CarModel model;
  final PageController pageController = PageController(initialPage: 0);

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
            icon: Icons.info_outline,
            spacerAfter: ToolbarSpacerType.none,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
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
                    height: isImageTransparent ? size.height * 0.26 : size.height * 0.38,
                    child: Center(
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: model.images!.length,
                            controller: pageController,
                            itemBuilder: (context, index) => CachedNetworkImage(
                              imageUrl:  model.images![index],
                              width: isImageTransparent ? size.width * 0.9 : size.width,
                              height: isImageTransparent ? size.height * 0.26 : size.height * 0.38,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, progress) {
                                return Center(
                                  child: CircularProgressIndicator.adaptive(
                                    value: progress.progress,
                                  ),
                                );
                              },
                              errorWidget: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/icons/car_placeholder.png",
                                  fit: isImageTransparent ? BoxFit.cover : BoxFit.cover,
                                  width: isImageTransparent ? size.width * 0.9 : size.width,
                                  height: isImageTransparent ? size.height * 0.26 : size.height * 0.38,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: pageController,
                                count: model.images!.length,
                                effect: const ExpandingDotsEffect(
                                  dotWidth: 10,
                                  dotHeight: 10,
                                  activeDotColor: AppColors.primary,
                                  dotColor: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
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
                          // Text(
                          //   "${model.description}........ Read More",
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     height: 1.5,
                          //     color: AppColors.textSecondary,
                          //   ),
                          // ),
                          ReadMoreText(
                            model.description,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: AppColors.textSecondary,
                            ),
                            trimLines: 3,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: "Read More",
                            trimExpandedText: "Show Less",
                            colorClickableText: AppColors.primary,
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
                            mainAxisSize: MainAxisSize.min,
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
                            ],
                          ),
                          const SizedBox(height: 20),
                          //  const SizedBox(height: 12),
                           const Text(
                            "Seller",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: (model.ownerProfileImage != null &&
                                          model.ownerProfileImage!.isNotEmpty)
                                      ? NetworkImage(model.ownerProfileImage!)
                                      : null,
                                  child: (model.ownerProfileImage == null ||
                                          model.ownerProfileImage!.isEmpty)
                                      ? Icon(
                                          Icons.person,
                                          color: Colors.grey.shade700,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.ownerName ?? "Seller",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                     model.ownerPhone != null ? Text(
                                      model.ownerPhone!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                    ) : const SizedBox.shrink()
                                  ],
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 100,
                                  height: 35,
                                  child: AdaptiveButton(
                                    label: "Chat",
                                    color: Colors.black,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
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
                        text: TextSpan(
                          text: "\$${model.pricePerDay.toStringAsFixed(0)}",
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
                      child: AdaptiveButton(
                        textColor: Colors.white,
                        style: AdaptiveButtonStyle.filled,
                        minSize: Size(140, 40),
                        size: AdaptiveButtonSize.large,
                        onPressed: () {
                          context.push(AppRoutes.bookRentalCar, extra: {"datePickerBloc": context.read<DatePickerBloc>(),"model": model});
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
                height: size.height * 0.12,
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
                maxLines: 1,
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
