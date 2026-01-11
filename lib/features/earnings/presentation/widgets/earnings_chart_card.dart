import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/earnings/presentation/widgets/earnings_time_range_selector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EarningsChartCard extends StatelessWidget {
  const EarningsChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.rangeLabels,
    required this.selectedRangeIndex,
    required this.onRangeChanged,
    required this.spots,
  });

  final String title;
  final String subtitle;
  final List<String> rangeLabels;
  final int selectedRangeIndex;
  final ValueChanged<int> onRangeChanged;
  final List<FlSpot> spots;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 190,
                child: EarningsTimeRangeSelector(
                  labels: rangeLabels,
                  selectedIndex: selectedRangeIndex,
                  onChanged: onRangeChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: LineChart(
                key: ValueKey<int>(selectedRangeIndex),
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.border.withValues(alpha: 0.7),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.black,
                      getTooltipItems: (items) {
                        return items
                            .map(
                              (e) => LineTooltipItem(
                                '\$${e.y.toStringAsFixed(0)}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                ),
                              ),
                            )
                            .toList();
                      },
                    ),
                  ),
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: spots,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primaryLight.withValues(alpha: 0.65),
                            AppColors.primaryLight.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
