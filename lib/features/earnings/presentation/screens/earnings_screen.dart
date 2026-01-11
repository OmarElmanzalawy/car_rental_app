import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_animated_in.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_balance_card.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_chart_card.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_quick_action_card.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_transaction_tile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  int _selectedRangeIndex = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final rangeLabels = const ['7D', '30D', '90D', '1Y'];
    final spots = _spotsForRange(_selectedRangeIndex);
    final history = _history;

    return AdaptiveScaffold(
      body: Material(
        color: Colors.transparent,
        child: Container(
          color: AppColors.background,
          child: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: Row(
                      children: [
                        const Text(
                          'Earnings',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        AdaptiveButton.icon(
                          onPressed: () {},
                          icon: Icons.tune_rounded,
                          color: AppColors.silverAccent,
                          iconColor: Colors.black,
                          style: AdaptiveButtonStyle.glass,
                          minSize: const Size(40, 40),
                          size: AdaptiveButtonSize.small,
                        ),
                        const SizedBox(width: 10),
                        AdaptiveButton.icon(
                          onPressed: () {},
                          icon: Icons.notifications_outlined,
                          color: AppColors.silverAccent,
                          iconColor: Colors.black,
                          style: AdaptiveButtonStyle.glass,
                          minSize: const Size(40, 40),
                          size: AdaptiveButtonSize.small,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: EarningsAnimatedIn(
                      child: EarningsBalanceCard(
                        availableBalanceText: '\$1,250.00',
                        lifetimeText: '\$4,980.00',
                        withdrawnText: '\$3,730.00',
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: EarningsAnimatedIn(
                      delay: const Duration(milliseconds: 80),
                      child: EarningsChartCard(
                        title: 'Earnings Over Time',
                        subtitle: 'Net earnings (demo)',
                        rangeLabels: rangeLabels,
                        selectedRangeIndex: _selectedRangeIndex,
                        onRangeChanged: (index) {
                          setState(() => _selectedRangeIndex = index);
                        },
                        spots: spots,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: EarningsAnimatedIn(
                      delay: const Duration(milliseconds: 160),
                      child: Row(
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
                  padding: EdgeInsets.fromLTRB(16, 0, 16, size.height * 0.14),
                  sliver: SliverList.separated(
                    itemCount: history.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return EarningsAnimatedIn(
                        delay: Duration(milliseconds: 260 + (index * 45)),
                        child: EarningsTransactionTile(
                          title: item.title,
                          subtitle: item.subtitle,
                          amountText: item.amountText,
                          icon: item.icon,
                          iconBackground: item.iconBackground,
                          amountColor: item.amountColor,
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<FlSpot> _spotsForRange(int index) {
    switch (index) {
      case 0:
        return const [
          FlSpot(0, 120),
          FlSpot(1, 160),
          FlSpot(2, 140),
          FlSpot(3, 210),
          FlSpot(4, 185),
          FlSpot(5, 240),
          FlSpot(6, 205),
        ];
      case 1:
        return const [
          FlSpot(0, 320),
          FlSpot(1, 280),
          FlSpot(2, 360),
          FlSpot(3, 310),
          FlSpot(4, 410),
          FlSpot(5, 390),
          FlSpot(6, 520),
          FlSpot(7, 480),
        ];
      case 2:
        return const [
          FlSpot(0, 520),
          FlSpot(1, 610),
          FlSpot(2, 560),
          FlSpot(3, 690),
          FlSpot(4, 640),
          FlSpot(5, 760),
          FlSpot(6, 720),
          FlSpot(7, 820),
        ];
      default:
        return const [
          FlSpot(0, 680),
          FlSpot(1, 720),
          FlSpot(2, 760),
          FlSpot(3, 740),
          FlSpot(4, 820),
          FlSpot(5, 860),
          FlSpot(6, 910),
          FlSpot(7, 980),
        ];
    }
  }
}

class _HistoryItem {
  const _HistoryItem({
    required this.title,
    required this.subtitle,
    required this.amountText,
    required this.amountColor,
    required this.icon,
    required this.iconBackground,
  });

  final String title;
  final String subtitle;
  final String amountText;
  final Color amountColor;
  final IconData icon;
  final Color iconBackground;
}

const List<_HistoryItem> _history = [
  _HistoryItem(
    title: 'Rental earning • Porsche 911',
    subtitle: 'Jan 12 • Completed',
    amountText: '+ \$210',
    amountColor: AppColors.primary,
    icon: Icons.directions_car_filled_outlined,
    iconBackground: AppColors.primaryLight,
  ),
  _HistoryItem(
    title: 'Platform fee',
    subtitle: 'Jan 12 • 15% applied',
    amountText: '- \$37',
    amountColor: Colors.black,
    icon: Icons.receipt_long_outlined,
    iconBackground: AppColors.silverAccent,
  ),
  _HistoryItem(
    title: 'Rental earning • Tesla Model 3',
    subtitle: 'Jan 09 • Completed',
    amountText: '+ \$165',
    amountColor: AppColors.primary,
    icon: Icons.directions_car_filled_outlined,
    iconBackground: AppColors.primaryLight,
  ),
  _HistoryItem(
    title: 'Withdrawal',
    subtitle: 'Jan 05 • Processing',
    amountText: '- \$300',
    amountColor: Colors.black,
    icon: Icons.account_balance_outlined,
    iconBackground: AppColors.silverAccent,
  ),
  _HistoryItem(
    title: 'Rental earning • BMW M4',
    subtitle: 'Dec 29 • Completed',
    amountText: '+ \$420',
    amountColor: AppColors.primary,
    icon: Icons.directions_car_filled_outlined,
    iconBackground: AppColors.primaryLight,
  ),
];
