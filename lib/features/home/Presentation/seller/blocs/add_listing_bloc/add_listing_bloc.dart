import 'package:bloc/bloc.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/features/home/data/car_remote_data_source.dart';
import 'package:car_rental_app/features/home/data/models/car_dto.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'add_listing_event.dart';
part 'add_listing_state.dart';

class AddListingBloc extends Bloc<AddListingEvent, AddListingState> {
  AddListingBloc() : super(const AddListingState()) {
    on<AddListingPageChanged>((event, emit) {
      emit(state.copyWith(currentPage: event.page));
    });

    on<AddListingBrandChanged>((event, emit) {
      emit(
        state.copyWith(
          selectedBrand: event.brand,
          selectedBrandChanged: true,
        ),
      );
    });

    on<AddListingGearboxChanged>((event, emit) {
      emit(
        state.copyWith(
          selectedGearbox: event.gearbox,
          selectedGearboxChanged: true,
        ),
      );
    });

    on<AddListingFuelTypeChanged>((event, emit) {
      emit(
        state.copyWith(
          selectedFuelType: event.fuelType,
          selectedFuelTypeChanged: true,
        ),
      );
    });

    on<AddListingImagesAdded>((event, emit) {
      emit(
        state.copyWith(
          pickedImages: [...state.pickedImages, ...event.images],
        ),
      );
    });

    on<AddListingPickedImageRemoved>((event, emit) {
      final next = [...state.pickedImages];
      if (event.index < 0 || event.index >= next.length) {
        return;
      }
      next.removeAt(event.index);
      emit(state.copyWith(pickedImages: next));
    });

    on<AddListingThumbnailPicked>((event, emit) {
      emit(
        state.copyWith(
          thumbnailImage: event.image,
          thumbnailImageChanged: true,
        ),
      );
    });

    on<AddListingThumbnailRemoved>((event, emit) {
      emit(
        state.copyWith(
          thumbnailImage: null,
          thumbnailImageChanged: true,
        ),
      );
    });

    on<AddListingSubmit>((event,emit)async{
      emit(state.copyWith(submissionStatus: ListingSubmissionStatus.loading));
      final success = await CarRemoteDataSourceImpl(Supabase.instance.client).addCarListing(event.carDto, state.thumbnailImage != null ? [state.thumbnailImage!,...event.images] : event.images);
      if(success){
        emit(state.copyWith(submissionStatus: ListingSubmissionStatus.success));
      }else{
        print("error while adding car listing");
        emit(state.copyWith(submissionStatus: ListingSubmissionStatus.failure));
      }
    });
  }
}
