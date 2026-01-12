import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/widgets/action_button.dart';
import 'package:car_rental_app/features/payment/presentation/widgets/withdraw_amount_header.dart';
import 'package:car_rental_app/features/payment/presentation/widgets/withdraw_from_account_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WithdrawEarningScreen extends StatefulWidget {
  const WithdrawEarningScreen({super.key});

  @override
  State<WithdrawEarningScreen> createState() => _WithdrawEarningScreenState();
}

class _WithdrawEarningScreenState extends State<WithdrawEarningScreen> {
  final TextEditingController _amountController = TextEditingController(text: '100');
  final TextEditingController _noteController = TextEditingController();

  int _selectedAccountIndex = 0;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Material(
      child: AdaptiveScaffold(
        body: Container(
          color: AppColors.background,
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: size.height * 0.40,
                    child: WithdrawAmountHeader(
                      amountController: _amountController,
                      noteLabel: _noteController.text.trim().isEmpty
                          ? 'Add note'
                          : 'Edit note',
                      title: 'Withdraw Amount',
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(26),
                          topRight: Radius.circular(26),
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                          child: Column(
                            children: [
                              Container(
                                width: 52,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: AppColors.border,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Send Earning to',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      WithdrawFromAccountTile(
                                        bankName: 'Axis Bank',
                                        maskedAccountNumber: 'XXXX XXXX 0124',
                                        balanceText: '\$5000',
                                        isSelected: _selectedAccountIndex == 0,
                                        onPressed: () {
                                          setState(() => _selectedAccountIndex = 0);
                                        },
                                        leading: _BankLogoBadge(
                                          backgroundColor:
                                              const Color(0xFFF7E9EC),
                                          icon: Icons.account_balance,
                                          iconColor: const Color(0xFFB00020),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      WithdrawFromAccountTile(
                                        bankName: 'Icici Bank',
                                        maskedAccountNumber: 'XXXX XXXX 0149',
                                        balanceText: '\$2000',
                                        isSelected: _selectedAccountIndex == 1,
                                        onPressed: () {
                                          setState(() => _selectedAccountIndex = 1);
                                        },
                                        leading: _BankLogoBadge(
                                          backgroundColor:
                                              const Color(0xFFFFF2E6),
                                          icon: Icons.account_balance,
                                          iconColor: const Color(0xFFB45309),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ActionButton(
                                label: 'Withdraw Earnings',
                                onPressed: () {},
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      AdaptiveButton.icon(
                        onPressed: () => context.pop(),
                        icon: Icons.arrow_back_ios_new,
                        color: Colors.white.withValues(alpha: 0.18),
                        iconColor: Colors.white,
                        style: AdaptiveButtonStyle.glass,
                        minSize: const Size(40, 40),
                        size: AdaptiveButtonSize.small,
                      ),
                      const Spacer(),
                      const SizedBox(width: 40, height: 40),
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

class _BankLogoBadge extends StatelessWidget {
  const _BankLogoBadge({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18, color: iconColor),
    );
  }
}
