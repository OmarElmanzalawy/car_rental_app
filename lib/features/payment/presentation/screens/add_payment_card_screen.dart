import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddPaymentCardScreen extends StatefulWidget {
  const AddPaymentCardScreen({super.key});

  @override
  State<AddPaymentCardScreen> createState() => _AddPaymentCardScreenState();
}

class _AddPaymentCardScreenState extends State<AddPaymentCardScreen> {
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Material(
      child: AdaptiveScaffold(
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
                              "Add Card",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 40, height: 40),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const _PaymentCardPreview(),
                        const SizedBox(height: 22),
                        const Text(
                          "Credit Card Info",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const _FieldLabel("Card Holder Name"),
                        const SizedBox(height: 10),
                        CustomTextfield(
                          hintText: "Enter your Name",
                          controller: nameController,
                          borderRadius: 14,
                          isFilled: true,
                          fillColor: AppColors.border.withValues(alpha: 0.30),
                          borderColor: Colors.transparent,
                          focusColor: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        const _FieldLabel("Card number*"),
                        const SizedBox(height: 10),
                        CustomTextfield(
                          hintText: "Enter your Card Number",
                          controller: cardNumberController,
                          keyboardType: TextInputType.number,
                          borderRadius: 14,
                          isFilled: true,
                          fillColor: AppColors.border.withValues(alpha: 0.30),
                          borderColor: Colors.transparent,
                          focusColor: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _FieldLabel("Expiry Date MM/YY*"),
                                  const SizedBox(height: 10),
                                  CustomTextfield(
                                    hintText: "Enter expiry date",
                                    controller: expiryController,
                                    keyboardType: TextInputType.datetime,
                                    borderRadius: 14,
                                    isFilled: true,
                                    fillColor: AppColors.border.withValues(
                                      alpha: 0.30,
                                    ),
                                    borderColor: Colors.transparent,
                                    focusColor: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: size.width * 0.28,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _FieldLabel("CVV"),
                                  const SizedBox(height: 10),
                                  CustomTextfield(
                                    hintText: "***",
                                    controller: cvvController,
                                    keyboardType: TextInputType.number,
                                    borderRadius: 14,
                                    isFilled: true,
                                    fillColor: AppColors.border.withValues(
                                      alpha: 0.30,
                                    ),
                                    borderColor: Colors.transparent,
                                    focusColor: AppColors.primary,
                                    obscureText: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                      isLiquidGlass: true,
                      label: "Save Card",
                      onPressed: () {},
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      liquidGlassSize: AdaptiveButtonSize.large,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }
}

class _PaymentCardPreview extends StatelessWidget {
  const _PaymentCardPreview();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          Container(
            height: 190,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  Color(0xFF1C2E8A),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _DotNoisePainter(),
            ),
          ),
          Positioned(
            left: 18,
            top: 16,
            child: Text(
              "??",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
          Positioned(
            right: 18,
            top: 76,
            child: Container(
              width: 58,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 18,
            bottom: 54,
            child: Text(
              "•••• •••• •••• ••••",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 20,
            child: Row(
              children: [
                Text(
                  "Expiry Date",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "** / **",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 18,
            bottom: 16,
            child: Image.asset(
              "assets/icons/mastercard.png",
              width: 58,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotNoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..style = PaintingStyle.fill;

    for (double y = -20; y < size.height * 0.55; y += 10) {
      for (double x = -20; x < size.width + 20; x += 10) {
        final t = (x * 0.02) + (y * 0.03);
        final radius = 0.6 + (t - t.floor()) * 1.2;
        final dx = x + (t - t.floor()) * 6;
        final dy = y + (t * 1.7 - (t * 1.7).floor()) * 6;
        canvas.drawCircle(Offset(dx, dy), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
