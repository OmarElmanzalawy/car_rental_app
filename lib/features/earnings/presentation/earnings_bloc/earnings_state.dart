part of 'earnings_bloc.dart';

class RentalHistoryInfo extends Equatable {
  const RentalHistoryInfo({
    required this.rentalId,
    required this.carTitle,
    required this.dropOffDate,
  });

  final String rentalId;
  final String carTitle;
  final DateTime? dropOffDate;

  @override
  List<Object?> get props => [rentalId, carTitle, dropOffDate];
}

class EarningsState extends Equatable {
  const EarningsState({
    this.sellerTransactions = const [],
    this.sellerEarnings = const [],
    this.sellerWallet,
    this.isFetching = false,
    this.selectedRangeIndex = 1,
    this.chartValues = const [],
    this.rentalHistoryByRentalId = const {},
    this.isWithdrawing = false,
    this.isWithdrawalSuccess,
  });

  final List<SellerTransactionModel> sellerTransactions;
  final List<SellerEarningModel> sellerEarnings;
  final SellerWalletModel? sellerWallet;
  final bool isFetching;
  final bool isWithdrawing;
  final int selectedRangeIndex;
  final List<double> chartValues;
  final Map<String, RentalHistoryInfo> rentalHistoryByRentalId;
  final bool? isWithdrawalSuccess;


  EarningsState copyWith({
    List<SellerTransactionModel>? sellerTransactions,
    List<SellerEarningModel>? sellerEarnings,
    SellerWalletModel? sellerWallet,
    bool? isFetching,
    int? selectedRangeIndex,
    bool? isWithdrawing,
    bool? isWithdrawalSuccess,
    List<double>? chartValues,
    Map<String, RentalHistoryInfo>? rentalHistoryByRentalId,
  }) {
    return EarningsState(
      sellerTransactions: sellerTransactions ?? this.sellerTransactions,
      sellerEarnings: sellerEarnings ?? this.sellerEarnings,
      sellerWallet: sellerWallet ?? this.sellerWallet,
      isFetching: isFetching ?? this.isFetching,
      isWithdrawing: isWithdrawing ?? this.isWithdrawing,
      isWithdrawalSuccess: isWithdrawalSuccess ?? this.isWithdrawalSuccess,
      selectedRangeIndex: selectedRangeIndex ?? this.selectedRangeIndex,
      chartValues: chartValues ?? this.chartValues,
      rentalHistoryByRentalId:
          rentalHistoryByRentalId ?? this.rentalHistoryByRentalId,
    );
  }
  
  @override
  List<Object?> get props => [
    sellerTransactions,
    sellerEarnings,
    sellerWallet,
    isFetching,
    selectedRangeIndex,
    chartValues,
    rentalHistoryByRentalId,
    isWithdrawing,
    isWithdrawalSuccess,
  ];
}
