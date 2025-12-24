import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/core/widgets/platform_nav_bar.dart';
import 'package:car_rental_app/features/chat/presentation/screens/users_list_screen.dart';
import 'package:car_rental_app/features/home/Presentation/customer/blocs/nav_bar_cubit/navigation_bar_cubit.dart';
import 'package:car_rental_app/features/home/Presentation/seller/blocs/seller_bloc/seller_bloc.dart';
import 'package:car_rental_app/features/home/Presentation/seller/widgets/seller_stat_tile.dart';
import 'package:car_rental_app/features/home/Presentation/seller/widgets/seller_vehicle_card.dart';
import 'package:car_rental_app/features/home/Presentation/widgets/earnings_card.dart';
import 'package:car_rental_app/features/profile/presentation/cubit/customer_profile_cubit.dart';
import 'package:car_rental_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationBarCubit()),
        BlocProvider(
          create: (_) => SellerBlocBloc()..add(const SellerListingsStarted()),
        ),
        BlocProvider(create: (_) => CustomerProfileCubit()..init()),
      ],
      child: AdaptiveScaffold(
        body: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              BlocBuilder<NavigationBarCubit, NavigationBarState>(
                builder: (context, state) {
                  return IndexedStack(
                    index: state.index,
                    children: [
                      const _DashboardContent(),
                      const _MyCarsContent(),
                      const UsersListScreen(),
                      const ProfileScreen(),
                    ],
                  );
                },
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PlatformNavBar(isSeller: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headerHeight = size.height * 0.41;
    return SingleChildScrollView(
      child: Column(
        children: [
          //Header Section
          Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: headerHeight,
                      width: size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.5, 1.0],
                          colors: [
                            Colors.blue.shade600,
                            Colors.grey.shade900,
                            Colors.blue.shade600,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            Row(
                              children: [
                                const Text(
                                  "My Garage",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                 AdaptiveButton.icon(
                              onPressed: () {},
                              icon: Icons.notifications_outlined,
                              size: AdaptiveButtonSize.small,
                              color: AppColors.primary,
                              padding: EdgeInsets.all(8),
                              iconColor: Colors.white,
                              style: AdaptiveButtonStyle.prominentGlass,
                              minSize: Size(38, 38),
                            ),
                              ],
                            ),
                            // const SizedBox(height: 12),
                            const SizedBox(height: 16),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                 
                                const CircleAvatar(
                                  backgroundImage: AssetImage("assets/images/profile.jpg"),
                                  radius: 50,
                                ),
                                const SizedBox(width: 20),
                                SizedBox(
                                  width: 250,
                                  height: 180,
                                  child: GridView.count(
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 1.5,
                                    children: const [
                                      SellerStatTile(label: "This Month", value: "\$1,450", delta: "+5.3%", isPositive: true),
                                      SellerStatTile(label: "This Week", value: "\$380", delta: "+2.1%", isPositive: true),
                                      SellerStatTile(label: "Today", value: "\$120", delta: "-0.4%", isPositive: false),
                                      SellerStatTile(label: "Pending", value: "\$300", delta: "+0.0%", isPositive: true),
                                    ],
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: AppColors.background,
                      height: 80,
                      )
                  ],
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text("Your Earnings", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: EarningsCard(),
                      ),
                    ],
                  ),
                  ),
              ],
            ),
          Container(
            color: AppColors.background,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "My Vehicles",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: size.width,
                    height: 45,
                    child: GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.addCarListing);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add,color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text("Add new vehicle", style: TextStyle(color: AppColors.primary,fontSize: 16, fontWeight: FontWeight.w600),),
                          ],
                        )
                        ),
                    )
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<SellerBlocBloc, SellerState>(
                    builder: (context, state) {
                      if (state.status == SellerListingsStatus.loading) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      }

                      if (state.status == SellerListingsStatus.failure) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            state.errorMessage ?? "Failed to load your listings.",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }

                      if (state.listings.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            "No vehicles yet. Add your first listing.",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.listings.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final car = state.listings[index];
                          final imagePath = (car.images?.isNotEmpty ?? false)
                              ? car.images!.first
                              : "assets/images/test_cars/tesla.png";
                          final statusLabel =
                              car.available ? "Available" : "Unavailable";
                          final statusColor = car.available
                              ? Colors.green.shade400
                              : Colors.grey.shade500;

                          return SellerVehicleCard(
                            imagePath: imagePath,
                            pricePerDay: car.pricePerDay,
                            statusChipColor: statusColor,
                            statusChipLabel: statusLabel,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyCarsContent extends StatelessWidget {
  const _MyCarsContent();
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("My Cars"));
  }
}
