part of 'seller_bloc.dart';

enum SellerListingsStatus { loading, success, failure }

class SellerState extends Equatable {
  const SellerState({
    this.status = SellerListingsStatus.loading,
    this.listings = const [],
    this.errorMessage,
  });

  final SellerListingsStatus status;
  final List<CarModel> listings;
  final String? errorMessage;

  SellerState copyWith({
    SellerListingsStatus? status,
    List<CarModel>? listings,
    String? errorMessage,
    bool errorMessageChanged = false,
  }) {
    return SellerState(
      status: status ?? this.status,
      listings: listings ?? this.listings,
      errorMessage: errorMessageChanged ? errorMessage : this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [status, listings, errorMessage];
}
