part of 'cars_bloc.dart';

sealed class CarsEvent extends Equatable {
  const CarsEvent();
  @override
  List<Object> get props => [];
}

class LoadCarsEvent extends CarsEvent {
  const LoadCarsEvent();
}


class FilterCarsByBrandEvent extends CarsEvent {
  final String brand;
  const FilterCarsByBrandEvent(this.brand);
  @override
  List<Object> get props => [brand];
}