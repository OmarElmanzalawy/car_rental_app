import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/home/Presentation/blocs/nav_bar_cubit/navigation_bar_cubit.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';


class PlatformNavBar extends StatelessWidget {
  const PlatformNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (context, platform) {
        return CustomBottomNavigationBar();
      },
      cupertino: (context, platform) {
        final isLiquidGlass = AppUtils.isiOS26OrAbove();

        return isLiquidGlass ? GlassNavBar() : CustomBottomNavigationBar();
      },
    );
  }
}


class GlassNavBar extends StatelessWidget {
  const GlassNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBarCubit, NavigationBarState>(
      builder: (context, state) {
        return CNTabBar(
          tint: Colors.blue.shade700,
          split: true,
          items: const [
            CNTabBarItem(
              icon: CNSymbol("car.fill"),
              label: "Cars",
            ),
            CNTabBarItem(
              icon: CNSymbol("calendar"),
              label: "Bookings",
            ),
            CNTabBarItem(
              icon: CNSymbol("ellipsis.message"),
              label: "Chat",
            ),
            CNTabBarItem(
              icon: CNSymbol("person"),
              // label: "Profile",
            ),
          ],
          currentIndex: state.index,
          onTap: (index) => context.read<NavigationBarCubit>().changeIndex(index),
          );
      },
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBarCubit, NavigationBarState>(
      builder: (context, state) {
        final currentIndex = state.index;
        
        return Container(
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, 0, Icons.directions_car, "Cars", currentIndex),
              _buildNavItem(context, 1, Icons.calendar_month_outlined, "Bookings", currentIndex),
              _buildNavItem(context, 2, Icons.chat_bubble_outline, "Chat", currentIndex),
              _buildNavItem(context, 3, Icons.person_outline, "Profile", currentIndex),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, int currentIndex) {
    final isSelected = index == currentIndex;
    
    return InkWell(
      onTap: () {
        context.read<NavigationBarCubit>().changeIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated Indicator Line
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: isSelected ? 20 : 0,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Icon(
            icon,
            color: isSelected ? Colors.black : Colors.grey.shade400,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.grey.shade400,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
