part of 'book_rental_cubit.dart';

final class BookRentalState {
  const BookRentalState({
    this.currentPosition,
    this.markerIcon,
    Set<Marker>? markers,
    this.pickupPosition,
    this.pickupAddress,
    this.phoneNumber,
    this.name,
    this.pickupDate,
    this.dropOffDate,
    this.totalPrice,
    this.rentalDuration,
    this.subtotoal,
    this.isCalculatingPrice = true,
    this.isHourly = false,
  }) : markers = markers ?? const {};

  //Map related fields
  final LatLng? currentPosition;
  final BitmapDescriptor? markerIcon;
  final Set<Marker> markers;
  final LatLng? pickupPosition;
  final String? pickupAddress;

  //booking related fields
  final String? phoneNumber;
  final String? name;
  final DateTime? pickupDate;
  final DateTime? dropOffDate;
  final double? totalPrice;
  final double? subtotoal; //price without tax and service fee
  final int? rentalDuration; //in days
  final bool isCalculatingPrice; //to show loading indicator while calculating price
  final bool isHourly;
  final double taxRate = 0.1; //10%
  final double serviceFeeRate = 0.05; //5%

  BookRentalState copyWith({
    LatLng? currentPosition,
    BitmapDescriptor? markerIcon,
    Set<Marker>? markers,
    LatLng? pickupPosition,
    String? pickupAddress,
    String? phoneNumber,
    String? name,
    DateTime? pickupDate,
    DateTime? dropOffDate,
    double? totalPrice,
    int? rentalDuration,
    double? subtotoal,
    bool? isCalculatingPrice,
    bool? isHourly,
    
  }) {
    return BookRentalState(
      currentPosition: currentPosition ?? this.currentPosition,
      markerIcon: markerIcon ?? this.markerIcon,
      markers: markers ?? this.markers,
      pickupPosition: pickupPosition ?? this.pickupPosition,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      pickupDate: pickupDate ?? this.pickupDate,
      dropOffDate: dropOffDate ?? this.dropOffDate,
      totalPrice: totalPrice ?? this.totalPrice,
      rentalDuration: rentalDuration ?? this.rentalDuration,
      subtotoal: subtotoal ?? this.subtotoal,
      isCalculatingPrice: isCalculatingPrice ?? this.isCalculatingPrice,
      isHourly: isHourly ?? this.isHourly,
    );
  }
}
