import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/widgets/platform_nav_bar.dart';
import 'package:car_rental_app/features/home/Presentation/customer/blocs/nav_bar_cubit/navigation_bar_cubit.dart';
import 'package:car_rental_app/features/profile/presentation/ui/profile_screen.dart';
import 'package:fl_chart/fl_chart.dart';
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
    final headerHeight = size.height * 0.35;
    return SingleChildScrollView(
      child: Column(
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
                  const SizedBox(height: 55),
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
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: SearchAnchor.bar(
                      barHintText: "Search my cars",
                      viewBackgroundColor: AppColors.background,
                      barBackgroundColor: const WidgetStatePropertyAll(AppColors.background),
                      barLeading: const Icon(Icons.search, color: Colors.black),
                      isFullScreen: false,
                      suggestionsBuilder: (context, controller) => [],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _MetricTile(icon: Icons.directions_car_filled, label: "Total Cars", value: "5"),
                      const SizedBox(width: 12),
                      _MetricTile(icon: Icons.vpn_key, label: "Rented Out", value: "2"),
                      const SizedBox(width: 12),
                      _MetricTile(icon: Icons.check_circle_outline, label: "Available", value: "3"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.background,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _EarningsCard(),
                  const SizedBox(height: 16),
                  const Text(
                    "My Vehicles",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _VehicleCard(
                    imagePath: "assets/images/test_cars/tesla.png",
                    pricePerDay: 120,
                    statusChip: _StatusChip(label: "Available", color: Colors.green.shade400),
                  ),
                  const SizedBox(height: 10),
                  _VehicleCard(
                    imagePath: "assets/images/test_cars/sclass.png",
                    pricePerDay: 160,
                    statusChip: _StatusChip(label: "Rented until Oct 28", color: Colors.blue.shade400),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Recent Bookings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  _BookingRow(
                    title: "John D. - Tesla Model 3 - Oct 26–28",
                    status: _StatusChip(label: "Confirmed", color: Colors.green.shade400),
                  ),
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

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("\$1,450", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                Text("this month", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
          ),
          SizedBox(
            height: 60,
            width: 120,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: const [
                      FlSpot(0, 2),
                      FlSpot(1, 2.8),
                      FlSpot(2, 2.4),
                      FlSpot(3, 3.2),
                      FlSpot(4, 2.9),
                      FlSpot(5, 3.8),
                      FlSpot(6, 3.2),
                    ],
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primaryLight.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Withdraw"),
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.imagePath,
    required this.pricePerDay,
    required this.statusChip,
  });
  final String imagePath;
  final int pricePerDay;
  final Widget statusChip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath, width: 120, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("\$$pricePerDay/day", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    statusChip,
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Edit Listing"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("View Calendar"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _BookingRow extends StatelessWidget {
  const _BookingRow({required this.title, required this.status});
  final String title;
  final Widget status;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          status,
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

class _InboxContent extends StatelessWidget {
  const _InboxContent();
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Inbox"));
  }
}
