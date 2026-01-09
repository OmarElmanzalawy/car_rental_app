import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/blocs/book_rental_cubit/book_rental_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutSummaryCard extends StatelessWidget {
  const CheckoutSummaryCard({
    super.key,
    required this.bookRentalCubit,
    this.pricePerDay,
    this.height,
    this.totalValueColor,
    this.showPricePerDay = true,
    this.showDuration = true,
  });

  final BookRentalCubit bookRentalCubit;
  final double? pricePerDay;
  final double? height;
  final Color? totalValueColor;
  final bool showPricePerDay;
  final bool showDuration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookRentalCubit, BookRentalState>(
      bloc: bookRentalCubit,
      buildWhen: (previous, current) {
        return previous.totalPrice != current.totalPrice ||
            previous.rentalDuration != current.rentalDuration ||
            previous.subtotoal != current.subtotoal ||
            previous.isCalculatingPrice != current.isCalculatingPrice ||
            previous.isHourly != current.isHourly;
      },
      builder: (context, state) {
        final isReady = !state.isCalculatingPrice &&
            state.totalPrice != null &&
            state.subtotoal != null &&
            state.rentalDuration != null;

        if (!isReady) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: height ?? 220,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: AppColors.border),
              ),
            ),
          );
        }

        final subtotal = state.subtotoal!;
        final serviceFee = subtotal * state.serviceFeeRate;
        final tax = subtotal * state.taxRate;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            children: [
              if (showPricePerDay && pricePerDay != null) ...[
                _SummaryRow(
                  label: "Price per day",
                  value: "\$${pricePerDay!.toStringAsFixed(0)}",
                ),
                const SizedBox(height: 8),
              ],
              if (showDuration) ...[
                _SummaryRow(
                  label: "Duration",
                  value:
                      "${state.rentalDuration} ${state.isHourly ? 'hours' : 'days'}",
                ),
                const SizedBox(height: 8),
              ],
              _SummaryRow(
                label: "Subtotal",
                value: "\$${subtotal.toStringAsFixed(0)}",
              ),
              const SizedBox(height: 8),
              _SummaryRow(
                label: "Service fee",
                value: "\$${serviceFee.toStringAsFixed(0)}",
              ),
              const SizedBox(height: 8),
              _SummaryRow(
                label: "Tax",
                value: "\$${tax.toStringAsFixed(0)}",
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _SummaryRow(
                label: "Total",
                value: "\$${state.totalPrice!.toStringAsFixed(2)}",
                isBold: true,
                valueColor: totalValueColor,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

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
            color: valueColor ?? (isBold ? AppColors.primary : Colors.black),
          ),
        ),
      ],
    );
  }
}
