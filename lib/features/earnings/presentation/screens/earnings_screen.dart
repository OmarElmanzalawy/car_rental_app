import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/earnings/presentation/earnings_bloc/earnings_bloc.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_animated_in.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_balance_card.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_chart_card.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_quick_action_card.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_shimmer.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_transaction_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final rangeLabels = const ['7D', '30D', '90D', '1Y'];

    return AdaptiveScaffold(
      body: Material(
        color: Colors.transparent,
        child: Container(
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: BlocBuilder<EarningsBloc, EarningsState>(
              builder: (context, state) {
                final wallet = state.sellerWallet;
                final availableText = wallet == null
                    ? '\$0.00'
                    : '\$${wallet.availableBalance.toStringAsFixed(2)}';
                final withdrawnText = wallet == null
                    ? '\$0.00'
                    : '\$${wallet.withdrawnBalance.toStringAsFixed(2)}';
                final lifetimeText = wallet == null
                    ? '\$0.00'
                    : '\$${wallet.lifetimeEarnings.toStringAsFixed(2)}';

                final values = state.chartValues.isEmpty
                    ? _defaultChartValues(state.selectedRangeIndex)
                    : state.chartValues;

                final isLoading = state.isFetching;
                final transactions = state.sellerTransactions;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const CupertinoSliverNavigationBar(
                      largeTitle: Text('Earnings'),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: EarningsAnimatedIn(
                          child: isLoading
                              ? const EarningsShimmerCard(height: 170)
                              : EarningsBalanceCard(
                                  availableBalanceText: availableText,
                                  lifetimeText: lifetimeText,
                                  withdrawnText: withdrawnText,
                                  onWithdrawPressed: () {
                                    context.push(AppRoutes.withdrawEarning);
                                  },
                                ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: EarningsAnimatedIn(
                          delay: const Duration(milliseconds: 80),
                          child: isLoading
                              ? const EarningsShimmerCard(height: 240)
                              : EarningsChartCard(
                                  title: 'Earnings Over Time',
                                  subtitle: 'Net earnings',
                                  rangeLabels: rangeLabels,
                                  selectedRangeIndex: state.selectedRangeIndex,
                                  onRangeChanged: (index) {
                                    context.read<EarningsBloc>().add(
                                          ChangeDateRangeEvent(index),
                                        );
                                  },
                                  values: values,
                                ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                        child: EarningsAnimatedIn(
                          delay: const Duration(milliseconds: 160),
                          child: isLoading
                              ? const Row(
                                  children: [
                                    Expanded(
                                      child: EarningsShimmerCard(height: 76),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: EarningsShimmerCard(height: 76),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: EarningsQuickActionCard(
                                        title: 'Payout Method',
                                        subtitle: 'Bank •••• 2148',
                                        icon: Icons.account_balance_outlined,
                                        iconBg: AppColors.primaryLight,
                                        onTap: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: EarningsQuickActionCard(
                                        title: 'Statements',
                                        subtitle: 'Monthly PDF',
                                        icon: Icons.description_outlined,
                                        iconBg: AppColors.silverAccent,
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                        child: EarningsAnimatedIn(
                          delay: const Duration(milliseconds: 220),
                          child: Row(
                            children: [
                              const Text(
                                'History',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding:
                          EdgeInsets.fromLTRB(16, 0, 16, size.height * 0.14),
                      sliver: isLoading
                          ? SliverList.separated(
                              itemCount: 6,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                return EarningsAnimatedIn(
                                  delay:
                                      Duration(milliseconds: 260 + (index * 45)),
                                  child: const EarningsShimmerListTile(),
                                );
                              },
                            )
                          : SliverList.separated(
                              itemCount: transactions.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final t = transactions[index];
                                final rentalId = t.rentalId;
                                final rentalInfo = rentalId == null
                                    ? null
                                    : state.rentalHistoryByRentalId[rentalId];

                                final title = rentalId != null &&
                                        (rentalInfo?.carTitle.isNotEmpty ?? false)
                                    ? '${_labelForType(t.type)} • ${rentalInfo!.carTitle}'
                                    : _labelForType(t.type);

                                final date = rentalId != null
                                    ? rentalInfo?.dropOffDate
                                    : t.createdAt;

                                final subtitle = rentalId != null
                                    ? 'Dropoff • ${AppUtils.toDayMonth(date ?? t.createdAt)}'
                                    : AppUtils.toDayMonth(t.createdAt);

                                final amountAbs =
                                    t.amount.abs().toStringAsFixed(0);

                                final amountText = switch (t.type) {
                                  TransactionType.rentalEarning =>
                                    '+ \$${amountAbs}',
                                  TransactionType.platformFee =>
                                    '- \$${amountAbs}',
                                  TransactionType.withDrawal =>
                                    '- \$${amountAbs}',
                                };

                                final (icon, iconBg, amountColor) =
                                    _uiForType(t.type);

                                return EarningsAnimatedIn(
                                  delay:
                                      Duration(milliseconds: 260 + (index * 45)),
                                  child: EarningsTransactionTile(
                                    title: title,
                                    subtitle: subtitle,
                                    amountText: amountText,
                                    icon: icon,
                                    iconBackground: iconBg,
                                    amountColor: amountColor,
                                    onTap: () {},
                                  ),
                                );
                              },
                            ),
                    ),
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

List<double> _defaultChartValues(int rangeIndex) {
  switch (rangeIndex) {
    case 0:
      return List<double>.filled(7, 0);
    case 1:
      return List<double>.filled(10, 0);
    case 2:
      return List<double>.filled(12, 0);
    default:
      return List<double>.filled(12, 0);
  }
}

String _labelForType(TransactionType type) {
  switch (type) {
    case TransactionType.rentalEarning:
      return 'Rental earning';
    case TransactionType.platformFee:
      return 'Platform fee';
    case TransactionType.withDrawal:
      return 'Withdrawal';
  }
}

(IconData, Color, Color) _uiForType(TransactionType type) {
  switch (type) {
    case TransactionType.rentalEarning:
      return (
        Icons.directions_car_filled_outlined,
        AppColors.primaryLight,
        AppColors.primary,
      );
    case TransactionType.platformFee:
      return (
        Icons.receipt_long_outlined,
        AppColors.silverAccent,
        Colors.black,
      );
    case TransactionType.withDrawal:
      return (
        Icons.account_balance_outlined,
        AppColors.silverAccent,
        Colors.black,
      );
  }
}
