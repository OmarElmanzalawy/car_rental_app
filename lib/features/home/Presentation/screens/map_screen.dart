import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/features/home/Presentation/blocs/map_cubit/map_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      await context.read<MapCubit>().loadMarkerIcon();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(),
      body: BlocListener<MapCubit, MapState>(
        listenWhen: (previous, current) => previous.currentPosition != current.currentPosition && current.currentPosition != null,
        listener: (context, state) {
          final pos = state.currentPosition!;
          _controller?.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: pos, zoom: 14),
            ),
          );
        },
        child: Container(
          height: size.height,
          width: size.width,
          child: BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              return GoogleMap(
                onMapCreated: (c) => _controller = c,
                onTap: (pos) => context.read<MapCubit>().setTapMarker(pos),
                initialCameraPosition: CameraPosition(
                  target: state.currentPosition ?? LatLng(39.208259265734636, 29.965139724025835),
                  zoom: 14,
                ),
                markers: state.markers,
              );
            },
          ),
        ),
      ),
    );
  }
}
