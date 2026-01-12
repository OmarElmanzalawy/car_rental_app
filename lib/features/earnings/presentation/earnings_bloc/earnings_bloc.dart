import 'package:bloc/bloc.dart';
import 'package:car_rental_app/features/earnings/data/earnings_data_source.dart';
import 'package:car_rental_app/features/earnings/data/models/seller_transaction_dto.dart';
import 'package:car_rental_app/features/earnings/data/models/seller_wallet_dto.dart';
import 'package:car_rental_app/features/earnings/domain/entities/seller_earning_model.dart';
import 'package:car_rental_app/features/earnings/domain/entities/seller_transaction_model.dart';
import 'package:car_rental_app/features/earnings/domain/entities/seller_wallet_model.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

part 'earnings_event.dart';
part 'earnings_state.dart';

class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {

  EarningsBloc({
    EarningsDataSource? dataSource,
    String? sellerId,
  })  : _dataSource = dataSource ?? EarningsDataSourceImpl(Supabase.instance.client),
        _sellerId = sellerId ?? Supabase.instance.client.auth.currentUser!.id,
        super(const EarningsState()) {
    on<InitEarningsEvent>(_onInit);
    on<GetSellerTransactionsEvent>(_onGetSellerTransactions);
    on<GetSellerWalletEvent>(_onGetSellerWallet);
    on<GetSellerEarningsEvent>(_onGetSellerEarnings);
    on<ChangeDateRangeEvent>(_onChangeDateRange);
    on<_SellerWalletUpdated>(_onSellerWalletUpdated);
    on<_SellerTransactionsUpdated>(_onSellerTransactionsUpdated);
    on<_RentalHistoryRequested>(_onRentalHistoryRequested);
  }

  final EarningsDataSource _dataSource;
  final String _sellerId;

  StreamSubscription<List<SellerTransactionDto>>? _transactionsSub;
  StreamSubscription<SellerWalletDto>? _walletSub;

  bool _hasWallet = false;
  bool _hasTransactions = false;
  bool _hasEarnings = false;
  int _rentalDetailsRequestId = 0;
  String _lastRentalIdsKey = '';

  Future<void> _onInit(
    InitEarningsEvent event,
    Emitter<EarningsState> emit,
  ) async {
    _hasWallet = false;
    _hasTransactions = false;
    _hasEarnings = false;

    emit(state.copyWith(isFetching: true));
    add(const GetSellerTransactionsEvent());
    add(const GetSellerWalletEvent());
    add(const GetSellerEarningsEvent());
  }

  Future<void> _onGetSellerTransactions(
    GetSellerTransactionsEvent event,
    Emitter<EarningsState> emit,
  ) async {
    await _transactionsSub?.cancel();
    _transactionsSub = _dataSource.getSellerTransactions(_sellerId).listen(
      (transactions) {
        final transactionModels = transactions.map((e) => e.toDomain()).toList();
        add(_SellerTransactionsUpdated(transactionModels));
      },
    );
  }

  Future<void> _onGetSellerWallet(
    GetSellerWalletEvent event,
    Emitter<EarningsState> emit,
  ) async {
    await _walletSub?.cancel();
    _walletSub = _dataSource.getSellerWallet(_sellerId).listen((wallet) {
      add(_SellerWalletUpdated(wallet.toDomain()));
    });
  }

  void _onSellerWalletUpdated(
    _SellerWalletUpdated event,
    Emitter<EarningsState> emit,
  ) {
    emit(state.copyWith(sellerWallet: event.wallet));
    _hasWallet = true;
    _maybeStopLoading(emit);
  }

  void _onSellerTransactionsUpdated(
    _SellerTransactionsUpdated event,
    Emitter<EarningsState> emit,
  ) {
    emit(state.copyWith(sellerTransactions: event.transactions));
    _hasTransactions = true;
    _maybeStopLoading(emit);

    final rentalIds = event.transactions
        .map((e) => e.rentalId)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    final key = rentalIds.join('|');
    if (key != _lastRentalIdsKey) {
      _lastRentalIdsKey = key;
      add(_RentalHistoryRequested(rentalIds));
    }
  }

  Future<void> _onRentalHistoryRequested(
    _RentalHistoryRequested event,
    Emitter<EarningsState> emit,
  ) async {
    final requestId = ++_rentalDetailsRequestId;
    final details = await _dataSource.getRentalHistoryDetails(event.rentalIds);
    if (requestId != _rentalDetailsRequestId) {
      return;
    }

    final map = <String, RentalHistoryInfo>{};
    for (final d in details) {
      final rentalId = d['rental_id'] as String?;
      if (rentalId == null) continue;

      final title = (d['car_title'] as String?)?.trim() ?? '';
      final rawEnd = d['end_date'];
      final endDate = rawEnd is String
          ? DateTime.tryParse(rawEnd)
          : rawEnd is DateTime
              ? rawEnd
              : null;
      map[rentalId] = RentalHistoryInfo(
        rentalId: rentalId,
        carTitle: title,
        dropOffDate: endDate,
      );
    }

    emit(state.copyWith(rentalHistoryByRentalId: map));
  }

  Future<void> _onGetSellerEarnings(
    GetSellerEarningsEvent event,
    Emitter<EarningsState> emit,
  ) async {
    final dtos = await _dataSource.getSellerEarnings(_sellerId);
    final earnings = dtos.map((e) => e.toDomain()).toList();
    emit(
      state.copyWith(
        sellerEarnings: earnings,
        chartValues: _buildChartValues(
          earnings: earnings,
          rangeIndex: state.selectedRangeIndex,
        ),
      ),
    );
    _hasEarnings = true;
    _maybeStopLoading(emit);
  }

  void _onChangeDateRange(
    ChangeDateRangeEvent event,
    Emitter<EarningsState> emit,
  ) {
    emit(
      state.copyWith(
        selectedRangeIndex: event.selectedRangeIndex,
        chartValues: _buildChartValues(
          earnings: state.sellerEarnings,
          rangeIndex: event.selectedRangeIndex,
        ),
      ),
    );
  }

  void _maybeStopLoading(Emitter<EarningsState> emit) {
    if (_hasWallet && _hasTransactions && _hasEarnings) {
      if (state.isFetching) {
        emit(state.copyWith(isFetching: false));
      }
    }
  }

  List<double> _buildChartValues({
    required List<SellerEarningModel> earnings,
    required int rangeIndex,
  }) {
    final now = DateTime.now();
    final int days;
    final int buckets;
    switch (rangeIndex) {
      case 0:
        days = 7;
        buckets = 7;
        break;
      case 1:
        days = 30;
        buckets = 10;
        break;
      case 2:
        days = 90;
        buckets = 12;
        break;
      default:
        days = 365;
        buckets = 12;
        break;
    }

    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: days - 1));
    final bucketSize = (days / buckets).ceil().clamp(1, days);

    final values = List<double>.filled(buckets, 0);
    for (final e in earnings) {
      final created = e.createdAt.toLocal();
      if (created.isBefore(start)) continue;
      final diffDays =
          DateTime(created.year, created.month, created.day).difference(start).inDays;
      final bucketIndex = (diffDays ~/ bucketSize).clamp(0, buckets - 1);
      values[bucketIndex] += e.netAmount;
    }

    return values;
  }

  @override
  Future<void> close() async {
    await _transactionsSub?.cancel();
    await _walletSub?.cancel();
    return super.close();
  }
}
