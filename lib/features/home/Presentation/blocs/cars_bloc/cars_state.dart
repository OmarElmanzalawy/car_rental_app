part of 'cars_bloc.dart';

enum CarsStatus {loading, loaded, error }

class CarsState {
  final CarsStatus status;
  final List<CarModel> topDealCars;
  final List<CarModel> availableNearYouCars;
  final String? message;

  const CarsState({
    this.status = CarsStatus.loading,
    this.topDealCars = const [],
    this.availableNearYouCars = const [],
    this.message,
  });

  CarsState copyWith({
    CarsStatus? status,
    List<CarModel>? topDealCars,
    List<CarModel>? availableNearYouCars,
    String? message,
  }) {
    return CarsState(
      status: status ?? this.status,
      topDealCars: topDealCars ?? this.topDealCars,
      availableNearYouCars: availableNearYouCars ?? this.availableNearYouCars,
      message: message ?? this.message,
    );
  }
}