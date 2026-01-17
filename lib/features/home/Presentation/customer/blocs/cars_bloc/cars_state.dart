part of 'cars_bloc.dart';

enum CarsStatus {loading, loaded, error }

class CarsState {
  final CarsStatus status;
  final List<CarModel> topDealCars;
  final List<CarModel> availableNearYouCars;
  final List<CarModel> allCars;
  final String? message;
  final String? selectedBrand;
  final bool inFilterMode;

  const CarsState({
    this.status = CarsStatus.loading,
    this.topDealCars = const [],
    this.availableNearYouCars = const [],
    this.allCars = const [],
    this.message,
    this.selectedBrand,
    this.inFilterMode = false,
  });

  CarsState copyWith({
    CarsStatus? status,
    List<CarModel>? topDealCars,
    List<CarModel>? availableNearYouCars,
    List<CarModel>? allCars,  
    String? message,
    String? selectedBrand,
    bool selectedBrandChanged = false,
    bool? inFilterMode,
  }) {
    return CarsState(
      status: status ?? this.status,
      topDealCars: topDealCars ?? this.topDealCars,
      availableNearYouCars: availableNearYouCars ?? this.availableNearYouCars,
      message: message ?? this.message,
      allCars: allCars ?? this.allCars,
      selectedBrand:
          selectedBrandChanged ? selectedBrand : this.selectedBrand,
      inFilterMode: inFilterMode ?? this.inFilterMode,
    );
  }
}
