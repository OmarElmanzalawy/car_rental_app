import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/widgets/platform_nav_bar.dart';
import 'package:car_rental_app/features/home/Presentation/customer/blocs/nav_bar_cubit/navigation_bar_cubit.dart';
import 'package:car_rental_app/features/home/Presentation/seller/widgets/seller_stat_tile.dart';
import 'package:car_rental_app/features/home/Presentation/seller/widgets/seller_vehicle_card.dart';
import 'package:car_rental_app/features/home/Presentation/widgets/earnings_card.dart';
import 'package:car_rental_app/features/profile/presentation/ui/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBarCubit(),
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
                      const _InboxContent(),
                      ProfileScreen(),
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
                  SellerVehicleCard(
                    imagePath: "assets/images/test_cars/tesla.png",
                    pricePerDay: 120,
                    statusChipColor: Colors.green.shade400,
                    statusChipLabel: "Available",
                  ),
                  const SizedBox(height: 10),
                  SellerVehicleCard(
                    imagePath: "assets/images/test_cars/sclass.png",
                    pricePerDay: 160,
                    statusChipColor: Colors.blue.shade400,
                    statusChipLabel: "Rented",
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


// class _BookingRow extends StatelessWidget {
//   const _BookingRow({required this.title, required this.status});
//   final String title;
//   final Widget status;
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
//           status,
//         ],
//       ),
//     );
//   }
// }

class _MyCarsContent extends StatelessWidget {
  const _MyCarsContent();
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("My Cars"));
  }
}

class _InboxContent extends StatelessWidget {
  const _InboxContent();
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Inbox"));
  }
}
