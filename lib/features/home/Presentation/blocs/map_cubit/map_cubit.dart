import 'dart:async';
import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/services/dialogue_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final BuildContext context;
  MapCubit(this.context) : super(MapState());

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
    emit(state.copyWith(currentPosition: LatLng(position.latitude, position.longitude)));
  }

  Future<void> loadMarkerIcon() async {
    final icon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/icons/marker.png',
    );
    emit(state.copyWith(markerIcon: icon));
  }

  void setTapMarker(LatLng position) {
    final marker = Marker(
      markerId: const MarkerId('tap-marker'),
      position: position,
      icon: state.markerIcon ?? BitmapDescriptor.defaultMarker,
    );
    emit(state.copyWith(markers: {marker},pickupPosition: position));
  }

}
