part of 'add_listing_bloc.dart';

sealed class AddListingEvent extends Equatable {
  const AddListingEvent();

  @override
  List<Object?> get props => [];
}

final class AddListingPageChanged extends AddListingEvent {
  const AddListingPageChanged(this.page);

  final int page;

  @override
  List<Object> get props => [page];
}

final class AddListingBrandChanged extends AddListingEvent {
  const AddListingBrandChanged(this.brand);

  final String? brand;

  @override
  List<Object?> get props => [brand];
}

final class AddListingGearboxChanged extends AddListingEvent {
  const AddListingGearboxChanged(this.gearbox);

  final GearBox? gearbox;

  @override
  List<Object?> get props => [gearbox];
}

final class AddListingFuelTypeChanged extends AddListingEvent {
  const AddListingFuelTypeChanged(this.fuelType);

  final FuelType? fuelType;

  @override
  List<Object?> get props => [fuelType];
}

final class AddListingImagesAdded extends AddListingEvent {
  const AddListingImagesAdded(this.images);

  final List<XFile> images;

  @override
  List<Object> get props => [images];
}

final class AddListingPickedImageRemoved extends AddListingEvent {
  const AddListingPickedImageRemoved(this.index);

  final int index;

  @override
  List<Object> get props => [index];
}

final class AddListingThumbnailPicked extends AddListingEvent {
  const AddListingThumbnailPicked(this.image);

  final XFile image;

  @override
  List<Object> get props => [image];
}

final class AddListingThumbnailRemoved extends AddListingEvent {
  const AddListingThumbnailRemoved();
}

final class AddListingSubmit extends AddListingEvent {
  const AddListingSubmit({required this.carDto,required this.images});

  final CarDto carDto;
  final List<XFile> images;

  @override
  List<Object> get props => [carDto,images];
}
