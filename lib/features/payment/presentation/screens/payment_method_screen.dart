import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/core/widgets/checkout_summary_card.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/blocs/book_rental_cubit/book_rental_cubit.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:car_rental_app/features/payment/presentation/widgets/delivery_address_card.dart';
import 'package:car_rental_app/features/payment/presentation/widgets/payment_methods_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({
    super.key,
    required this.bookRentalCubit,
    required this.carModel,
  });

  final BookRentalCubit bookRentalCubit;
  final CarModel carModel;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int selectedMethodIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AdaptiveScaffold(
      body: BlocSelector<BookRentalCubit, BookRentalState, bool>(
        selector: (state) {
          return state.didSubmit;
        },
        bloc: widget.bookRentalCubit,
        builder: (context, didSubmit) {
          return Stack(
            children: [
              Container(
                color: AppColors.background,
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AdaptiveButton.icon(
                                    onPressed: () => context.pop(),
                                    icon: Icons.arrow_back_ios_new,
                                    color: AppColors.silverAccent,
                                    iconColor: Colors.black,
                                    style: AdaptiveButtonStyle.glass,
                                    minSize: const Size(40, 40),
                                    size: AdaptiveButtonSize.small,
                                  ),
                                  const Spacer(),
                                  const Text(
                                    "Payment Method",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Spacer(),
                                  AdaptiveButton.icon(
                                    onPressed: () {},
                                    icon: Icons.more_horiz,
                                    color: AppColors.silverAccent,
                                    iconColor: Colors.black,
                                    style: AdaptiveButtonStyle.glass,
                                    minSize: const Size(40, 40),
                                    size: AdaptiveButtonSize.small,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              PaymentMethodsCard(
                                selectedIndex: selectedMethodIndex,
                                onSelect: (index) {
                                  setState(() => selectedMethodIndex = index);
                                },
                                onAddPressed: () =>
                                    context.push(AppRoutes.addPaymentCard),
                              ),
                              const SizedBox(height: 26),
                              const Text(
                                "Pickup Address",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              DeliveryAddressCard(
                                title:
                                    widget
                                        .bookRentalCubit
                                        .state
                                        .pickupAddress ??
                                    "Not specified",
                                //TODO: change to include city
                                subtitle: "Egypt",
                              ),
                              const SizedBox(height: 26),
                              const Text(
                                "Order Summary",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              CheckoutSummaryCard(
                                bookRentalCubit: widget.bookRentalCubit,
                                showPricePerDay: false,
                                totalValueColor: AppColors.primary,
                              ),
                              SizedBox(height: size.height * 0.03),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: ActionButton(
                            label: "Pay Now",
                            onPressed: () async {
                              await widget.bookRentalCubit.bookRentalCar(
                                widget.carModel,
                              );
                              await widget.bookRentalCubit.saveUserInfo(
                                name: widget.bookRentalCubit.state.name,
                                phoneNumber:
                                    widget.bookRentalCubit.state.phoneNumber,
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
                                    onPressed: () {
                                      context.go(AppRoutes.bookRentalCar);
                                    },
                                    style: AlertActionStyle.primary,
                                  ),
                                ],
                              );
                            },
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              didSubmit ? 
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(
                      
                    ),
                  ),
                )
              ) : const SizedBox.shrink()
            ],
          );
        },
      ),
    );
  }
}
