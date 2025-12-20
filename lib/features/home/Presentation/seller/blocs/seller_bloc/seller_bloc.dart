import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:car_rental_app/features/home/data/car_remote_data_source.dart';
import 'package:car_rental_app/features/home/data/models/car_dto.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'seller_event.dart';
part 'seller_state.dart';

class SellerBlocBloc extends Bloc<SellerBlocEvent, SellerState> {
  SellerBlocBloc({
    CarRemoteDataSource? remoteDataSource,
  })  : _remoteDataSource =
            remoteDataSource ?? CarRemoteDataSourceImpl(Supabase.instance.client),
        super(const SellerState()) {
    on<SellerListingsStarted>(_onListingsStarted);
    on<SellerListingsUpdated>(_onListingsUpdated);
    on<SellerListingsFailed>(_onListingsFailed);
  }

  final CarRemoteDataSource _remoteDataSource;
  StreamSubscription<List<CarDto>>? _subscription;

  Future<void> _onListingsStarted(
    SellerListingsStarted event,
    Emitter<SellerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SellerListingsStatus.loading,
        errorMessage: null,
        errorMessageChanged: true,
      ),
    );

    await _subscription?.cancel();
    _subscription = _remoteDataSource.fetchSellerListings().listen(
      (dtos) {
        final listings = dtos.map((e) => e.toEntity()).toList();
        add(SellerListingsUpdated(listings));
      },
      onError: (error) {
        add(SellerListingsFailed(error.toString()));
      },
    );
  }

  void _onListingsUpdated(
    SellerListingsUpdated event,
    Emitter<SellerState> emit,
  ) {
    emit(
      state.copyWith(
        status: SellerListingsStatus.success,
        listings: event.listings,
      ),
    );
  }

  void _onListingsFailed(
    SellerListingsFailed event,
    Emitter<SellerState> emit,
  ) {
    emit(
      state.copyWith(
        status: SellerListingsStatus.failure,
        errorMessage: event.message,
        errorMessageChanged: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
