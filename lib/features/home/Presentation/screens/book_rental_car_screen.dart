import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/auth/Presentation/widgets/custom_textfield.dart';
import 'package:car_rental_app/features/home/Presentation/blocs/map_cubit/map_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookRentalCarScreen extends StatefulWidget {
  const BookRentalCarScreen({super.key});

  @override
  State<BookRentalCarScreen> createState() => _BookRentalCarScreenState();
}

class _BookRentalCarScreenState extends State<BookRentalCarScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  GoogleMapController? _pickupMapController;

  DateTime? _startDate;
  DateTime? _endDate;

  final double _ratePerDay = 340;
  final int _sampleDays = 3;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                          controller: _nameController,
                          hintText: "Enter your name",
                          keyboardType: TextInputType.name,
                          prefixIcon: Icons.person_outline,
                          cursorColor: AppColors.textPrimary,
                          borderColor: AppColors.border,
                          focusColor: AppColors.primary,
                        ),
                        const SizedBox(height: 12),
                        CustomTextfield(
                          controller: _phoneController,
                          hintText: "Enter your phone number",
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          cursorColor: AppColors.textPrimary,
                          borderColor: AppColors.border,
                          focusColor: AppColors.primary,
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
                        BlocListener<MapCubit, MapState>(
                          listenWhen: (previous, current) => previous.currentPosition != current.currentPosition && current.currentPosition != null,
                          listener: (context, state) {
                            final pos = state.currentPosition!;
                            _pickupMapController?.moveCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(target: pos, zoom: 14.4746),
                              ),
                            );
                          },
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              color: AppColors.silverAccent.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Stack(
                              children: [
                                AbsorbPointer(
                                  absorbing: true,
                                  child: BlocBuilder<MapCubit, MapState>(
                                    builder: (context, state) {
                                      return GoogleMap(
                                        onMapCreated: (c) => _pickupMapController = c,
                                        tiltGesturesEnabled: false,
                                        scrollGesturesEnabled: false,
                                        rotateGesturesEnabled: false,
                                        zoomGesturesEnabled: false,
                                        myLocationButtonEnabled: false,
                                        zoomControlsEnabled: false,
                                        initialCameraPosition: CameraPosition(
                                          target: state.currentPosition ?? LatLng(
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
                                      extra: context.read<MapCubit>(),
                                    ),
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                              ],
            ),
          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          "Duration",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.silverAccent.withOpacity(
                                    0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _startDate == null
                                              ? "Select date"
                                              : _dateLabel(_startDate!),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.silverAccent.withOpacity(
                                    0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "End",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          _endDate == null
                                              ? "Select date"
                                              : _dateLabel(_endDate!),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            border: Border.all(color: AppColors.border),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          child: Column(
                            children: [
                              _SummaryRow(
                                label: "Price per day",
                                value: "\$${_ratePerDay.toStringAsFixed(0)}",
                              ),
                              const SizedBox(height: 8),
                              _SummaryRow(
                                label: "Duration",
                                value: "${_sampleDays} days",
                              ),
                              const SizedBox(height: 8),
                              _SummaryRow(
                                label: "Subtotal",
                                value:
                                    "\$${(_ratePerDay * _sampleDays).toStringAsFixed(0)}",
                              ),
                              const SizedBox(height: 8),
                              _SummaryRow(label: "Service fee", value: "\$25"),
                              const SizedBox(height: 8),
                              _SummaryRow(label: "Tax", value: "\$60"),
                              const SizedBox(height: 12),
                              const Divider(height: 1),
                              const SizedBox(height: 12),
                              _SummaryRow(
                                label: "Total",
                                value:
                                    "\$${((_ratePerDay * _sampleDays) + 25 + 60).toStringAsFixed(0)}",
                                isBold: true,
                              ),
                            ],
                          ),
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
                            onPressed: () {},
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
          ),
        ),
    );
  }

  String _dateLabel(DateTime d) {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${months[d.month - 1]} ${d.day}, ${d.year}";
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
