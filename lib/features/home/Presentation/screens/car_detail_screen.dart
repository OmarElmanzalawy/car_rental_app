import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/core/widgets/oval_top_clipper.dart';
import 'package:car_rental_app/features/home/Presentation/blocs/date_picker_bloc/date_picker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class CarDetailScreen extends StatelessWidget {
  const CarDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: "\tCar details\t",
        // leading: Icon(Icons.phone),
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
          bottom: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    SizedBox(
                      height: size.height * 0.27,
                      child: Center(
                        child: Image.asset(
                          "assets/images/test_cars/sclass.png",
                          fit: BoxFit.cover,
                          width: size.width * 0.8,
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
                                const Text(
                                  "Audi Q7",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "4.8",
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
                            const SizedBox(height: 10),
                            Text(
                              "The Audi Q7 is a luxury 7-seater SUV that combines powerful performance, it a premium choice for both long drives and family trips........ Read More",
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: AppColors.textSecondary,
                              ),
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
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                _DetailTile(
                                  icon: Icons.speed,
                                  label: "Max Speed",
                                  value: "438 Km/h",
                                ),
                                _DetailTile(
                                  icon: Icons.airline_seat_recline_normal,
                                  label: "Ability",
                                  value: "4 Seats",
                                ),
                                _DetailTile(
                                  icon: Icons.door_front_door,
                                  label: "Door",
                                  value: "2 Door",
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<DatePickerBloc, DatePickerState>(
                              builder: (context, state) {
                                final currentMonth = state.months[state.monthIndex];
                                final days = AppUtils.first30DaysOfMonth(currentMonth);
                                final selectedDate = state.selectedDate;
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppUtils.monthYearLabel(currentMonth),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            _RoundIconButton(
                                              icon: Icons.chevron_left,
                                              onPressed: (){
                                                context
                                                    .read<DatePickerBloc>()
                                                    .add(PreviousMonthEvent());
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            _RoundIconButton(
                                              icon: Icons.chevron_right,
                                              onPressed:() {
                                                context.read<DatePickerBloc>().add(NextMonthEvent());
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    LayoutBuilder(
                                      builder: (context, constraints) {
                                        final width = constraints.maxWidth;
                                        final estimated = (width / 72).floor();
                                        final columns = math.max(
                                          4,
                                          math.min(7, estimated),
                                        );
                                        return GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: days.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: columns,
                                                mainAxisSpacing: 8,
                                                crossAxisSpacing: 8,
                                                childAspectRatio: 1,
                                              ),
                                          itemBuilder: (context, index) {
                                            final d = days[index];
                                            final isSelected =
                                                selectedDate != null &&
                                                selectedDate.year == d.year &&
                                                selectedDate.month ==
                                                    d.month &&
                                                selectedDate.day == d.day;
                                            return GestureDetector(
                                              onTap: () {
                                                context.read<DatePickerBloc>().add(SelectDateEvent(selectedDate: d));
                                              },
                                              child: _DateChip(
                                                dayLabel: AppUtils.shortWeekday(
                                                  d,
                                                ),
                                                date: d.day,
                                                selected: isSelected,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),

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
                            print("book now clicked");
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
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.silverAccent.withOpacity(0.4),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
  });
  final String dayLabel;
  final int date;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary
            : AppColors.silverAccent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayLabel,
            style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
