import 'package:bloc/bloc.dart';
import 'package:car_rental_app/features/home/data/car_remote_data_source.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'cars_event.dart';
part 'cars_state.dart';

class CarsBloc extends Bloc<CarsEvent, CarsState> {
  CarsBloc() : super(CarsState()) {
    final remoteClient = CarRemoteDataSourceImpl(Supabase.instance.client);
    on<LoadCarsEvent>((event, emit) async {
      try {
        emit(state.copyWith(status: CarsStatus.loading, message: null));

        final dtos = await remoteClient.fetchAll();
        final cars = dtos.map((e) => e.toEntity()).toList();

        final topDeals = cars.where((element) => element.isTopDeal && element.available).toList();
        final availableNearYou =
            cars.where((element) => !element.isTopDeal && element.available).toList();

        emit(
          state.copyWith(
            status: CarsStatus.loaded,
            availableNearYouCars: availableNearYou,
            topDealCars: topDeals,
            allCars: cars,
          ),
        );
      } catch (e) {
        emit(state.copyWith(status: CarsStatus.error, message: e.toString()));
      }
    });

    on<FilterCarsByBrandEvent>((event, emit) async {
      final nextSelectedBrand = (state.selectedBrand != null &&
              state.selectedBrand!.toLowerCase() == event.brand.toLowerCase())
          ? null
          : event.brand;

      final filtered = nextSelectedBrand == null
          ? state.allCars
          : state.allCars
              .where(
                (car) => car.brand.toLowerCase() == nextSelectedBrand.toLowerCase(),
              )
              .toList();

      final topDeals = filtered.where((car) => car.isTopDeal).toList();
      final availableNearYou = filtered.where((car) => !car.isTopDeal).toList();

      emit(
        state.copyWith(
          selectedBrand: nextSelectedBrand,
          selectedBrandChanged: true,
          topDealCars: topDeals,
          availableNearYouCars: availableNearYou,
        ),
      );
    });
  }
}
