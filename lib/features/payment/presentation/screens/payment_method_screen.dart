import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/features/payment/presentation/widgets/delivery_address_card.dart';
import 'package:car_rental_app/features/payment/presentation/widgets/order_summary_card.dart';
import 'package:car_rental_app/features/payment/presentation/widgets/payment_methods_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int selectedMethodIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return AdaptiveScaffold(
      body: Container(
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
                        onAddPressed: () => context.push(AppRoutes.addPaymentCard),
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        "Delivery Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const DeliveryAddressCard(
                        title: "A3/4, Jawhra, Jeddah",
                        subtitle: "Riyadh (SA)",
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
                      const OrderSummaryCard(
                        orderAmount: 80.00,
                        promoCode: 2.20,
                        delivery: 6.00,
                        tax: 2.00,
                        totalAmount: 85.80,
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
                    onPressed: () {},
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
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
