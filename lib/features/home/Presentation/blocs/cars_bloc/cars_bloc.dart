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
      final dtos = await remoteClient.fetchAll();
      final cars = dtos.map((e) => e.toEntity()).toList();
      print("Loaded cars: $cars");
      emit(state.copyWith(status: CarsStatus.loaded, availableNearYouCars: cars));
    } catch (e) {
      emit(state.copyWith(status: CarsStatus.error, message: e.toString()));
    }
    });
  }
}
