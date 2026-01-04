import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SellerRentalProgressBar extends StatelessWidget {
  const SellerRentalProgressBar({
    super.key,
    required this.start,
    required this.end,
    required this.now,
  });

  final DateTime start;
  final DateTime end;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final totalMs = end.difference(start).inMilliseconds;
    final elapsedMs = now.difference(start).inMilliseconds;

    final progress = totalMs <= 0
        ? 0.0
        : (elapsedMs / totalMs).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        const carSize = 22.0;
        final leftInset = carSize / 2;
        final rightInset = carSize / 2;

        final carX = leftInset + (trackWidth - leftInset - rightInset) * progress;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _DateMarker(label: _dayLabel(start)),
                const Spacer(),
                _DateMarker(label: _dayLabel(end), alignEnd: true),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 28,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    top: 13,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 13,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 8,
                    child: _EndpointDot(active: progress > 0),
                  ),
                  Positioned(
                    right: 0,
                    top: 8,
                    child: _EndpointDot(active: progress >= 1),
                  ),
                  Positioned(
                    left: carX - (carSize / 2),
                    top: 0,
                    child: Container(
                      width: carSize,
                      height: carSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.directions_car_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _dayLabel(DateTime dt) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final weekday = weekdays[(dt.weekday - 1).clamp(0, 6)];
    return '$weekday ${dt.day}';
  }
}

class _EndpointDot extends StatelessWidget {
  const _EndpointDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.primary : Colors.white,
        border: Border.all(color: AppColors.border),
      ),
    );
  }
}

class _DateMarker extends StatelessWidget {
  const _DateMarker({required this.label, this.alignEnd = false});

  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: alignEnd ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

