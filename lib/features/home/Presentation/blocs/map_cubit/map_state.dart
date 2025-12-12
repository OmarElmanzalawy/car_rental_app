part of 'map_cubit.dart';

final class MapState {
  const MapState({this.currentPosition, this.markerIcon, Set<Marker>? markers,this.pickupPosition,this.pickupAddress})
      : markers = markers ?? const {};

  final LatLng? currentPosition;
  final BitmapDescriptor? markerIcon;
  final Set<Marker> markers;
  final LatLng? pickupPosition;
  final String? pickupAddress;

  MapState copyWith({LatLng? currentPosition, BitmapDescriptor? markerIcon, Set<Marker>? markers,LatLng? pickupPosition,String? pickupAddress}) {
    return MapState(
      currentPosition: currentPosition ?? this.currentPosition,
      markerIcon: markerIcon ?? this.markerIcon,
      markers: markers ?? this.markers,
      pickupPosition: pickupPosition ?? this.pickupPosition,
      pickupAddress: pickupAddress ?? this.pickupAddress,
    );
  }
}
