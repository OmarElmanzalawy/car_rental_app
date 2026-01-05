import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/widgets/labeled_value_card.dart';
import 'package:car_rental_app/core/widgets/phone_textfield.dart';
import 'package:car_rental_app/core/widgets/custom_textfield.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/blocs/book_rental_cubit/book_rental_cubit.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/blocs/date_picker_bloc/date_picker_bloc.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shimmer/shimmer.dart';

class BookRentalCarScreen extends StatefulWidget {
  const BookRentalCarScreen({
    super.key,
    required this.datePickerBloc,
    required this.carModel,
  });

  final DatePickerBloc datePickerBloc;
  final CarModel carModel;

  @override
  State<BookRentalCarScreen> createState() => _BookRentalCarScreenState();
}

class _BookRentalCarScreenState extends State<BookRentalCarScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  GoogleMapController? _pickupMapController;
  final double _ratePerDay = 340;
  final int _sampleDays = 3;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: "EG");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<BookRentalCubit>().loadInfo(
        widget.datePickerBloc,
        widget.carModel,
      );
      context.read<BookRentalCubit>().calculateTotalPrice(widget.carModel);
      final name = context.read<BookRentalCubit>().state.name;
      if (name != null) {
        _nameController.text = name;
      }
      final phoneNumber = context.read<BookRentalCubit>().state.phoneNumber;
      if (phoneNumber != null) {
        _phoneController.text = phoneNumber;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: BlocBuilder<BookRentalCubit, BookRentalState>(
              buildWhen: (previous, current) => previous.didSubmit != current.didSubmit,
              builder: (context, state) {
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: AdaptiveButton.icon(
                                onPressed: () {
                                  context.pop();
                                },
                                icon: Icons.arrow_back_ios_new,
                                size: AdaptiveButtonSize.large,
                                style: AdaptiveButtonStyle.prominentGlass,
                                useSmoothRectangleBorder: false,
                                iconColor: Colors.white,
                                color: Colors.blue.shade600,
                                minSize: Size(45, 40),
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
                              top: Radius.circular(24),
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
                                const Text(
                                  "Your Details",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                CustomTextfield(
                                  isEnabled:
                                      context
                                          .read<BookRentalCubit>()
                                          .state
                                          .name ==
                                      null,
                                  controller: _nameController,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return "This field can't be empty";
                                    }
                                    return null;
                                  },
                                  hintText: "Enter your name",
                                  keyboardType: TextInputType.name,
                                  prefixIcon: Icons.person_outline,
                                  cursorColor: AppColors.textPrimary,
                                  borderColor: AppColors.border,
                                  focusColor: AppColors.primary,
                                ),
                                const SizedBox(height: 12),
                                PhoneTextfield(
                                  onSubmit: (value) {
                                    context
                                        .read<BookRentalCubit>()
                                        .setPhoneNumber(value);
                                  },
                                  enabled:
                                      context
                                          .read<BookRentalCubit>()
                                          .state
                                          .phoneNumber ==
                                      null,
                                  initialCountry: "EG",
                                  phoneNumber: _phoneNumber,
                                  phoneController: _phoneController,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                const Text(
                                  "Pickup Location",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                BlocListener<BookRentalCubit, BookRentalState>(
                                  listenWhen: (previous, current) =>
                                      previous.currentPosition !=
                                          current.currentPosition &&
                                      current.currentPosition != null,
                                  listener: (context, state) {
                                    final pos = state.currentPosition!;
                                    _pickupMapController?.moveCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                          target: pos,
                                          zoom: 14.4746,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 160,
                                    decoration: BoxDecoration(
                                      color: AppColors.silverAccent.withOpacity(
                                        0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColors.border,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        AbsorbPointer(
                                          absorbing: true,
                                          child:
                                              BlocBuilder<
                                                BookRentalCubit,
                                                BookRentalState
                                              >(
                                                buildWhen: (previous, current) {
                                                  return previous
                                                              .currentPosition !=
                                                          current
                                                              .currentPosition ||
                                                      previous.markers !=
                                                          current.markers;
                                                },
                                                builder: (context, state) {
                                                  return GoogleMap(
                                                    onMapCreated: (c) =>
                                                        _pickupMapController =
                                                            c,
                                                    tiltGesturesEnabled: false,
                                                    scrollGesturesEnabled:
                                                        false,
                                                    rotateGesturesEnabled:
                                                        false,
                                                    zoomGesturesEnabled: false,
                                                    myLocationButtonEnabled:
                                                        false,
                                                    zoomControlsEnabled: false,
                                                    initialCameraPosition: CameraPosition(
                                                      target:
                                                          state
                                                              .currentPosition ??
                                                          LatLng(
                                                            31.208259265734636,
                                                            29.965139724025835,
                                                          ),
                                                      zoom: 14.4746,
                                                    ),
                                                    markers: state.markers,
                                                  );
                                                },
                                              ),
                                        ),
                                        Positioned.fill(
                                          child: GestureDetector(
                                            onTap: () => context.push(
                                              AppRoutes.map,
                                              extra: context
                                                  .read<BookRentalCubit>(),
                                            ),
                                            child: Container(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                BlocBuilder<BookRentalCubit, BookRentalState>(
                                  buildWhen: (previous, current) =>
                                      previous.pickupAddress !=
                                      current.pickupAddress,
                                  builder: (context, state) {
                                    return state.pickupAddress == null
                                        ? const SizedBox.shrink()
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                              top: 12.0,
                                            ),
                                            child: Row(
                                              spacing: 4,
                                              children: [
                                                Spacer(),
                                                Icon(
                                                  Icons.location_on,
                                                  color: AppColors.primary,
                                                  size: 20,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    state.pickupAddress!,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Duration",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                BlocBuilder<BookRentalCubit, BookRentalState>(
                                  buildWhen: (previous, current) {
                                    //only rebuild when start or drop off date changed
                                    return previous.pickupDate !=
                                            current.pickupDate ||
                                        previous.dropOffDate !=
                                            current.dropOffDate;
                                  },
                                  builder: (context, state) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: LabeledValueCard(
                                                label: "Start",
                                                value: state.pickupDate == null
                                                    ? "Select date"
                                                    : AppUtils.toDayMonth(
                                                        state.pickupDate!,
                                                      ),
                                                icon: Icons.calendar_today,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: LabeledValueCard(
                                                label: "End",
                                                value: state.dropOffDate == null
                                                    ? "Select date"
                                                    : AppUtils.toDayMonth(
                                                        state.dropOffDate!,
                                                      ),
                                                icon: Icons.calendar_today,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: LabeledValueCard(
                                                label: "Pickup Time",
                                                value: state.pickupDate == null
                                                    ? "Select time"
                                                    : AppUtils.toReadableTime(
                                                        state.pickupDate!,
                                                      ),
                                                icon: Icons.access_time,
                                                onTap: state.pickupDate == null
                                                    ? null
                                                    : () {
                                                        AdaptiveTimePicker.show(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay(
                                                                hour: 12,
                                                                minute: 0,
                                                              ),
                                                        ).then((value) {
                                                          if (value == null)
                                                            return;
                                                          context
                                                              .read<
                                                                BookRentalCubit
                                                              >()
                                                              .setPickupTime(
                                                                value,
                                                                widget.carModel,
                                                              );
                                                        });
                                                      },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: LabeledValueCard(
                                                label: "Drop-off Time",
                                                value: state.dropOffDate == null
                                                    ? "Select time"
                                                    : AppUtils.toReadableTime(
                                                        state.dropOffDate!,
                                                      ),
                                                icon: Icons.access_time,
                                                onTap: state.dropOffDate == null
                                                    ? null
                                                    : () {
                                                        AdaptiveTimePicker.show(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay(
                                                                hour: 12,
                                                                minute: 0,
                                                              ),
                                                        ).then((value) {
                                                          print(value);
                                                          if (value == null)
                                                            return;
                                                          context
                                                              .read<
                                                                BookRentalCubit
                                                              >()
                                                              .setDropOffTime(
                                                                value,
                                                                widget.carModel,
                                                              );
                                                        });
                                                      },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  "Checkout",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                BlocBuilder<BookRentalCubit, BookRentalState>(
                                  buildWhen: (previous, current) {
                                    return previous.totalPrice !=
                                            current.totalPrice ||
                                        previous.rentalDuration !=
                                            current.rentalDuration ||
                                        previous.subtotoal !=
                                            current.subtotoal ||
                                        previous.isCalculatingPrice !=
                                            current.isCalculatingPrice;
                                  },
                                  builder: (context, state) {
                                    return state.isCalculatingPrice
                                        ? Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                              width: double.infinity,
                                              height: size.height * 0.3,
                                              decoration: BoxDecoration(
                                                color: AppColors.surface,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 5),
                                                  ),
                                                ],
                                                border: Border.all(
                                                  color: AppColors.border,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: AppColors.surface,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.05),
                                                  blurRadius: 20,
                                                  offset: const Offset(0, 5),
                                                ),
                                              ],
                                              border: Border.all(
                                                color: AppColors.border,
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 14,
                                            ),
                                            child: Column(
                                              children: [
                                                _SummaryRow(
                                                  label: "Price per day",
                                                  value:
                                                      "\$${widget.carModel.pricePerDay.toStringAsFixed(0)}",
                                                ),
                                                const SizedBox(height: 8),
                                                _SummaryRow(
                                                  label: "Duration",
                                                  value:
                                                      "${state.rentalDuration} ${state.isHourly ? 'hours' : 'days'}",
                                                ),
                                                const SizedBox(height: 8),
                                                _SummaryRow(
                                                  label: "Subtotal",
                                                  value:
                                                      "\$${(state.subtotoal!.toStringAsFixed(0))}",
                                                ),
                                                const SizedBox(height: 8),
                                                _SummaryRow(
                                                  label: "Service fee",
                                                  value:
                                                      "\$${(state.subtotoal! * state.serviceFeeRate).toStringAsFixed(0)}",
                                                ),
                                                const SizedBox(height: 8),
                                                _SummaryRow(
                                                  label: "Tax",
                                                  value:
                                                      "\$${(state.subtotoal! * state.taxRate).toStringAsFixed(0)}",
                                                ),
                                                const SizedBox(height: 12),
                                                const Divider(height: 1),
                                                const SizedBox(height: 12),
                                                _SummaryRow(
                                                  label: "Total",
                                                  value:
                                                      "\$${state.totalPrice!.toStringAsFixed(2)}",
                                                  isBold: true,
                                                ),
                                              ],
                                            ),
                                          );
                                  },
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: AdaptiveButton(
                                    style: AdaptiveButtonStyle.filled,
                                    textColor: Colors.white,
                                    size: AdaptiveButtonSize.large,
                                    minSize: const Size(140, 44),
                                    label: "Submit Booking",
                                    onPressed: () async {
                                      final formValid =
                                          _formKey.currentState?.validate() ??
                                          false;
                                      print(
                                        formValid
                                            ? "Form is valid"
                                            : "not valid",
                                      );
                                      final s = context
                                          .read<BookRentalCubit>()
                                          .state;
                                      final hasName =
                                          (s.name?.trim().isNotEmpty ??
                                              false) ||
                                          _nameController.text
                                              .trim()
                                              .isNotEmpty;
                                      final hasPhone =
                                          (s.phoneNumber?.trim().isNotEmpty ??
                                          false);
                                      final hasAddress =
                                          s.pickupAddress != null &&
                                          s.pickupAddress!.trim().isNotEmpty;
                                      final hasDates =
                                          s.pickupDate != null &&
                                          s.dropOffDate != null;
                                      if (!formValid ||
                                          !hasName ||
                                          !hasPhone ||
                                          !hasAddress ||
                                          !hasDates) {
                                        await DialogueService.showAdaptiveAlertDialog(
                                          context,
                                          title: "Incomplete form",
                                          content:
                                              "Please enter name, phone, pickup address, and select start and end.",
                                          actions: [
                                            AlertAction(
                                              title: "OK",
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              style: AlertActionStyle.primary,
                                            ),
                                          ],
                                        );
                                        return;
                                      }
                                      await context
                                          .read<BookRentalCubit>()
                                          .bookRentalCar(widget.carModel);
                                      await context
                                          .read<BookRentalCubit>()
                                          .saveUserInfo(
                                            name: s.name,
                                            phoneNumber: s.phoneNumber,
                                          );

                                      //show success dialog
                                      await DialogueService.showAdaptiveAlertDialog(
                                        context,
                                        title: "Success",
                                        content:
                                            "Your booking has been submitted. you will be notified if owner accepts your request.",
                                        actions: [
                                          AlertAction(
                                            title: "OK",
                                            onPressed: () => context.pop(),
                                            style: AlertActionStyle.primary,
                                          ),
                                        ],
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                    state.didSubmit ?
                    Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator.adaptive(
                        
                      ),
                    ),
                  ),
                )
                : const SizedBox.shrink()
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });
  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: isBold ? AppColors.primary : Colors.black,
          ),
        ),
      ],
    );
  }
}
