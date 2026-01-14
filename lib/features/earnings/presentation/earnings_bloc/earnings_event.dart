part of 'earnings_bloc.dart';

sealed class EarningsEvent extends Equatable {
  const EarningsEvent();

  @override
  List<Object> get props => [];
}

class InitEarningsEvent extends EarningsEvent {
  const InitEarningsEvent();
}

class ChangeDateRangeEvent extends EarningsEvent {
  const ChangeDateRangeEvent(this.selectedRangeIndex);

  final int selectedRangeIndex;

  @override
  List<Object> get props => [selectedRangeIndex];
}

class GetSellerTransactionsEvent extends EarningsEvent {
  const GetSellerTransactionsEvent();
}

class GetSellerWalletEvent extends EarningsEvent {
  const GetSellerWalletEvent();
}

class GetSellerEarningsEvent extends EarningsEvent {
  const GetSellerEarningsEvent();
}

class SellerWithdrawEvent extends EarningsEvent {
  const SellerWithdrawEvent(this.amount);

  final double amount;

  @override
  List<Object> get props => [amount];
}

final class _SellerWalletUpdated extends EarningsEvent {
  const _SellerWalletUpdated(this.wallet);

  final SellerWalletModel wallet;

  @override
  List<Object> get props => [wallet];
}

final class _SellerTransactionsUpdated extends EarningsEvent {
  const _SellerTransactionsUpdated(this.transactions);

  final List<SellerTransactionModel> transactions;

  @override
  List<Object> get props => [transactions];
}

final class _RentalHistoryRequested extends EarningsEvent {
  const _RentalHistoryRequested(this.rentalIds);

  final List<String> rentalIds;

  @override
  List<Object> get props => [rentalIds];
}


