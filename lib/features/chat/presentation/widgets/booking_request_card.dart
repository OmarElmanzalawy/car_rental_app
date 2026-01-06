import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/chat/domain/entities/message_model.dart';
import 'package:car_rental_app/features/chat/presentation/chat_bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingRequestCard extends StatefulWidget {
  const BookingRequestCard({super.key, required this.messageModel});

  final MessageModel messageModel;

  @override
  State<BookingRequestCard> createState() => _BookingRequestCardState();
}

class _BookingRequestCardState extends State<BookingRequestCard> {
  late Future<_BookingRequestUiData?> _future;
  
  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_BookingRequestUiData?> _load() async {
    final rentalId = widget.messageModel.rentalId;
    if (rentalId == null || rentalId.isEmpty) {
      return null;
    }

    final client = Supabase.instance.client;
    final rentalRow = await client
        .from('rentals')
        .select('id, car_id, start_date, end_date, total_price, status, pickup_address')
        .eq('id', rentalId)
        .maybeSingle();

    if (rentalRow == null) {
      return null;
    }

    final carId = rentalRow['car_id'] as String?;
    if (carId == null || carId.isEmpty) {
      return null;
    }

    final carRow = await client
        .from('cars')
        .select('id, title, price_per_day, owner_id')
        .eq('id', carId)
        .maybeSingle();

    final start = DateTime.parse(rentalRow['start_date'] as String);
    final end = DateTime.parse(rentalRow['end_date'] as String);
    final total = (rentalRow['total_price'] as num).toDouble();
    final status = RentalStatus.values.byName(rentalRow['status'] as String);
    final pickupAddress = rentalRow['pickup_address'] as String? ?? '';

    final pricePerDay = carRow?['price_per_day'] is num
        ? (carRow!['price_per_day'] as num).toDouble()
        : null;
    final daysRaw = end.difference(start).inDays;
    final days = daysRaw <= 0 ? 1 : daysRaw;
    final subtotal = pricePerDay != null ? pricePerDay * days : null;
    final fees = (subtotal != null) ? (total - subtotal) : null;

    return _BookingRequestUiData(
      rentalId: rentalId,
      carTitle: carRow?['title'] as String? ?? 'Booking request',
      carOwnerId: carRow?['owner_id'] as String?,
      startDate: start,
      endDate: end,
      pickupAddress: pickupAddress,
      total: total,
      subtotal: subtotal,
      fees: fees != null && fees > 0 ? fees : 0,
      status: status,
    );
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final rentalId = widget.messageModel.rentalId;

    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          current is ChatBookingActionSuccess &&
          current.rentalId == rentalId,
      listener: (context, state) => _refresh(),
      child: FutureBuilder<_BookingRequestUiData?>(
        future: _future,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _Shell(
              child: SizedBox(
                height: 110,
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppColors.silverAccent,
                  ),
                ),
              ),
            );
          }

          if (data == null) {
            return _Shell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking request',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.messageModel.content,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final currentUserId = Supabase.instance.client.auth.currentUser?.id;
          final canAct = currentUserId != null &&
              data.carOwnerId != null &&
              currentUserId == data.carOwnerId &&
              data.status == RentalStatus.pending;

          return _Shell(
            child: BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (previous, current) =>
                  current is ChatBookingActionInProgress ||
                  current is ChatBookingActionSuccess ||
                  current is ChatBookingActionFailure,
              builder: (context, state) {
                final isProcessing = state is ChatBookingActionInProgress &&
                    state.rentalId == data.rentalId;

                final dateRange =
                    '${AppUtils.toDayMonth(data.startDate)} - ${AppUtils.toDayMonth(data.endDate)}';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Booking request',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        _StatusPill(status: data.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dateRange,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data.carTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: AppColors.border,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pickup',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                data.pickupAddress,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'From ${AppUtils.toDayMonth(data.startDate)} ${AppUtils.toReadableTime(data.startDate)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'To ${AppUtils.toDayMonth(data.endDate)} ${AppUtils.toReadableTime(data.endDate)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _PriceRow(
                                label: 'Subtotal',
                                value: data.subtotal != null
                                    ? '\$${data.subtotal!.toStringAsFixed(0)}'
                                    : '-',
                                emphasize: false,
                              ),
                              const SizedBox(height: 6),
                              _PriceRow(
                                label: 'Fees',
                                value: '\$${data.fees.toStringAsFixed(0)}',
                                emphasize: false,
                              ),
                              const SizedBox(height: 6),
                              _PriceRow(
                                label: 'Tax',
                                value: '\$0',
                                emphasize: false,
                              ),
                              const SizedBox(height: 10),
                              _PriceRow(
                                label: 'Total',
                                value: '\$${data.total.toStringAsFixed(0)}',
                                emphasize: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (canAct) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: AdaptiveButton(
                              label: isProcessing ? 'Processing…' : 'Approve',
                              style: AdaptiveButtonStyle.filled,
                              color: AppColors.primary,
                              textColor: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              minSize: const Size(0, 44),
                              onPressed: isProcessing
                                  ? null
                                  : () {
                                      context.read<ChatBloc>().add(
                                            BookingRequestResponded(
                                              rentalId: data.rentalId,
                                              status: RentalStatus.approved,
                                            ),
                                          );
                                    },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AdaptiveButton(
                              label: isProcessing ? 'Processing…' : 'Reject',
                              style: AdaptiveButtonStyle.glass,
                              color: AppColors.surface,
                              textColor: Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              minSize: const Size(0, 44),
                              onPressed: isProcessing
                                  ? null
                                  : () {
                                      context.read<ChatBloc>().add(
                                            BookingRequestResponded(
                                              rentalId: data.rentalId,
                                              status: RentalStatus.rejected,
                                            ),
                                          );
                                    },
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (!canAct && data.status == RentalStatus.pending) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Waiting for owner response',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final RentalStatus status;

  @override
  Widget build(BuildContext context) {
    final label = AppUtils.capitalize(status.name);
    final Color bg;
    final Color fg;

    switch (status) {
      case RentalStatus.pending:
        bg = AppColors.primaryLight;
        fg = AppColors.primary;
        break;
      case RentalStatus.approved:
      case RentalStatus.active:
      case RentalStatus.completed:
        bg = Colors.green.withValues(alpha: 0.12);
        fg = Colors.green.shade700;
        break;
      case RentalStatus.canceled || RentalStatus.rejected || RentalStatus.expired:
        bg = Colors.red.withValues(alpha: 0.12);
        fg = Colors.red.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: bg),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    required this.emphasize,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      fontSize: 12,
      fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
      color: emphasize ? Colors.black : AppColors.textSecondary,
    );

    final TextStyle valueStyle = TextStyle(
      fontSize: 12,
      fontWeight: emphasize ? FontWeight.w900 : FontWeight.w700,
      color: Colors.black,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _BookingRequestUiData {
  const _BookingRequestUiData({
    required this.rentalId,
    required this.carTitle,
    required this.carOwnerId,
    required this.startDate,
    required this.endDate,
    required this.pickupAddress,
    required this.total,
    required this.subtotal,
    required this.fees,
    required this.status,
  });

  final String rentalId;
  final String carTitle;
  final String? carOwnerId;
  final DateTime startDate;
  final DateTime endDate;
  final String pickupAddress;
  final double total;
  final double? subtotal;
  final double fees;
  final RentalStatus status;
}
