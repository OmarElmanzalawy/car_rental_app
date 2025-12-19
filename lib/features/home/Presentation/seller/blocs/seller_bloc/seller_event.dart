part of 'seller_bloc.dart';

sealed class SellerBlocEvent extends Equatable {
  const SellerBlocEvent();

  @override
  List<Object> get props => [];
}

final class SellerListingsStarted extends SellerBlocEvent {
  const SellerListingsStarted();
}

final class SellerListingsUpdated extends SellerBlocEvent {
  const SellerListingsUpdated(this.listings);

  final List<CarModel> listings;

  @override
  List<Object> get props => [listings];
}

final class SellerListingsFailed extends SellerBlocEvent {
  const SellerListingsFailed(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
