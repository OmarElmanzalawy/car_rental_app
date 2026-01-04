import 'dart:async';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/enums.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/blocs/date_picker_bloc/date_picker_bloc.dart';
import 'package:car_rental_app/features/bookings/data/book_rental_data_source.dart';
import 'package:car_rental_app/features/bookings/data/geocoding_api.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:car_rental_app/features/bookings/domain/entities/rental_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'book_rental_state.dart';

class BookRentalCubit extends Cubit<BookRentalState> {
  final BuildContext context;
  BookRentalCubit(this.context) : super(BookRentalState());

  //gets user name and phone number from supabase and gets date set from date picker bloc
  Future<void> loadInfo(DatePickerBloc datePickerBloc, CarModel carModel)async{
    final userInfo = await BookRentalDataSourceImpl(Supabase.instance.client).fetchUserInfo();
    final phoneNumber = userInfo?['phone_number'] as String?;
    final name = userInfo?['full_name'] as String?;

    if(phoneNumber == null && name == null){
      print("user info is null");
      if(!isClosed){
        emit(state.copyWith(pickupDate: datePickerBloc.state.startDate, dropOffDate: datePickerBloc.state.endDate));
      }
      return;
    }
      if (!isClosed) {
      emit(state.copyWith(
        phoneNumber: phoneNumber,
        name: name,
        pickupDate: datePickerBloc.state.startDate,
        dropOffDate: datePickerBloc.state.endDate ?? datePickerBloc.state.startDate,
      ));
    }
  }

  // TODO FINISH IMPLEMENTING THIS
  void calculateTotalPrice(CarModel carModel){
    if(!state.isCalculatingPrice){
      emit(state.copyWith(isCalculatingPrice: true));
    }
    final start = state.pickupDate;
    final end = state.dropOffDate;
    if(start == null){
      return;
    }
    final diff = (end ?? start).difference(start);
    final hours = diff.inHours;
    final effectiveHours = hours <= 0 ? 1 : hours;
    final isHourly = effectiveHours < 24;
    final pricePerDay = carModel.pricePerDay;

    int durationValue;
    double subtotal;
    if(isHourly){
      durationValue = effectiveHours;
      subtotal = (pricePerDay / 24) * effectiveHours;
    }else{
      final days = diff.inDays <= 0 ? 1 : diff.inDays;
      durationValue = days;
      subtotal = days * pricePerDay;
    }
    final serviceFee = subtotal * state.serviceFeeRate;
    final tax = subtotal * state.taxRate;
    final totalPrice = subtotal + serviceFee + tax;

    if (!isClosed) {
      emit(state.copyWith(
        totalPrice: totalPrice, 
        rentalDuration: durationValue,
        subtotoal: subtotal,
        isHourly: isHourly,
        isCalculatingPrice: false,
      ));
    }
  }

  void setPickupTime(TimeOfDay time,CarModel carModel){
    if (!isClosed) {
      final date = DateTime(
        state.pickupDate!.year,
        state.pickupDate!.month,
        state.pickupDate!.day,
        time.hour,
        time.minute,
      );
      emit(state.copyWith(pickupDate: date));
      calculateTotalPrice(carModel);
    }
  }

  void setDropOffTime(TimeOfDay time,CarModel carModel){
    if (!isClosed) {
      final date = DateTime(
        state.dropOffDate!.year,
        state.dropOffDate!.month,
        state.dropOffDate!.day,
        time.hour,
        time.minute,
      );
      emit(state.copyWith(dropOffDate: date));
      calculateTotalPrice(carModel);
    }
  }

  Future<bool> checkPermission()async{

    final permission = await Permission.location.request();

    print("permission status: ${permission.name}");


    if(permission == PermissionStatus.denied || permission == PermissionStatus.permanentlyDenied){

      await DialogueService.showAdaptiveAlertDialog(
        context,
        title: 'Location permission denied',
        content: 'Please grant location permission to use the map',
        actions: [
           AlertAction(
            title: "Open settings",
            onPressed: () => openAppSettings(),
            style: AlertActionStyle.primary
          ),
          AlertAction(
            title: 'Cancel',
            onPressed: () => context.pop(),
            style: AlertActionStyle.cancel
          ),
        ],
      );

      return false;
    }else{
      return true;
    }
  }

  Future<void> getPickupAddress()async{
    if(state.pickupPosition == null){
      print("pickup position is null");
      return;
    }
    final address = await GeocodingApi.getPlaceName(state.pickupPosition!.latitude, state.pickupPosition!.longitude);
    print("pickup address: $address");
    if (!isClosed) {
      emit(state.copyWith(pickupAddress: address));
    }
  }

  void setPhoneNumber(String phoneNumber){
    if (!isClosed) {
      emit(state.copyWith(phoneNumber: phoneNumber));
    }
  }
  

  Future<void> getUserCurrentPosition()async{
    final hasPermission = await checkPermission();
    if(!hasPermission){
      print("user doesn't have permission");
      //requset permission again
      
      return;
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high)
    );
    print("current user position: $position");
    if (!isClosed) {
      emit(state.copyWith(currentPosition: LatLng(position.latitude, position.longitude)));
    }
  }

  Future<void> loadMarkerIcon() async {
    final icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/icons/marker.png',
    );
    if (!isClosed) {
      emit(state.copyWith(markerIcon: icon));
    }
  }

  void setTapMarker(LatLng position) {
    final marker = Marker(
      markerId: const MarkerId('tap-marker'),
      position: position,
      icon: state.markerIcon ?? BitmapDescriptor.defaultMarker,
    );
    if (!isClosed) {
      emit(state.copyWith(markers: {marker}, pickupPosition: position));
    }
  }

  Future<void> bookRentalCar(CarModel carModel)async{
    if(state.isCalculatingPrice){
      return;
    }
    emit(state.copyWith(didSubmit: true));
    final rentalModel = RentalModel(
      id: Uuid().v4(),
      customerId: Supabase.instance.client.auth.currentUser!.id,
      carId: carModel.id,
      pickupDate: state.pickupDate!,
      dropOffDate: state.dropOffDate!,
      totalPrice: state.totalPrice!,
      status: RentalStatus.pending,
      pickupLoc: state.pickupPosition!,
      pickupAddress: state.pickupAddress!,
      createdAt: DateTime.now()
      );

      await BookRentalDataSourceImpl(Supabase.instance.client).bookRentalCar(rentalModel,carModel , carModel.ownerId,state.name!);
      if (!isClosed) {
        emit(state.copyWith(didSubmit: false));
      }
  }

  Future<void> saveUserInfo({String? name, String? phoneNumber})async{
    await BookRentalDataSourceImpl(Supabase.instance.client).saveUserInfo(name: name, phoneNumber: phoneNumber);
  }

}
