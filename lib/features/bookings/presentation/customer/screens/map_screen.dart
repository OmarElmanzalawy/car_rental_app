import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/features/bookings/presentation/customer/blocs/book_rental_cubit/book_rental_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<BookRentalCubit>().loadMarkerIcon();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(),
      body: BlocListener<BookRentalCubit, BookRentalState>(
        listenWhen: (previous, current) =>
            previous.currentPosition != current.currentPosition &&
            current.currentPosition != null,
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
          child: Stack(
            children: [
              BlocBuilder<BookRentalCubit, BookRentalState>(
                builder: (context, state) {
                  return GoogleMap(
                    onMapCreated: (c) => _controller = c,
                    onTap: (pos) => context.read<BookRentalCubit>().setTapMarker(pos),
                    initialCameraPosition: CameraPosition(
                      target:
                          state.currentPosition ??
                          LatLng(39.208259265734636, 29.965139724025835),
                      zoom: 14,
                    ),
                    markers: state.markers,
                    zoomControlsEnabled: false,
                  );
                },
              ),
              BlocBuilder<BookRentalCubit, BookRentalState>(
                builder: (context, state) {
                  return Positioned(
                    bottom: 20,
                    right: 20,
                    child: AdaptiveButton(
                      onPressed: () async {
                        await context.read<BookRentalCubit>().getPickupAddress();
                        context.pop();
                      },
                      enabled: state.pickupPosition != null,
                      label: "Confirm pickup",
                      color: AppColors.primary,
                      textColor: Colors.white,
                      size: AdaptiveButtonSize.medium,
                      minSize: Size(70, 40),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
