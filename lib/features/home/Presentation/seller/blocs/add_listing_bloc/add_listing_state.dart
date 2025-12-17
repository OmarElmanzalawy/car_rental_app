part of 'add_listing_bloc.dart';


class AddListingState extends Equatable {
  const AddListingState({
    this.currentPage = 0,
    this.selectedBrand,
    this.selectedGearbox = GearBox.automatic,
    this.selectedFuelType = FuelType.petrol,
    this.pickedImages = const [],
    this.submitSuccessful = false
  });

  final int currentPage;
  final String? selectedBrand;
  final GearBox? selectedGearbox;
  final FuelType? selectedFuelType;
  final List<XFile> pickedImages;
  final bool submitSuccessful;

  AddListingState copyWith({
    int? currentPage,
    String? selectedBrand,
    bool selectedBrandChanged = false,
    GearBox? selectedGearbox,
    bool selectedGearboxChanged = false,
    FuelType? selectedFuelType,
    bool selectedFuelTypeChanged = false,
    List<XFile>? pickedImages,
    bool? submitSuccessful,
  }) {
    return AddListingState(
      currentPage: currentPage ?? this.currentPage,
      selectedBrand:
          selectedBrandChanged ? selectedBrand : this.selectedBrand,
      selectedGearbox:
          selectedGearboxChanged ? selectedGearbox : this.selectedGearbox,
      selectedFuelType:
          selectedFuelTypeChanged ? selectedFuelType : this.selectedFuelType,
      pickedImages: pickedImages ?? this.pickedImages,
      submitSuccessful: submitSuccessful ?? this.submitSuccessful,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        selectedBrand,
        selectedGearbox,
        selectedFuelType,
        pickedImages,
        submitSuccessful,
      ];
}
