class SellerWalletModel {

  final String sellerId;
  //Withdrawable balance
  final double availableBalance;
  final double withdrawnBalance;

  double get lifetimeEarnings => availableBalance + withdrawnBalance;

  final DateTime updatedAt;

  SellerWalletModel({
    required this.sellerId,
    required this.availableBalance,
    required this.withdrawnBalance,
    required this.updatedAt,
  });

}