import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/utils/app_utils.dart';
import 'package:car_rental_app/features/home/Presentation/customer/blocs/nav_bar_cubit/navigation_bar_cubit.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';


class PlatformNavBar extends StatelessWidget {
  const PlatformNavBar({super.key, this.isSeller = false});

  final bool isSeller;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      material: (context, platform) {
        return CustomBottomNavigationBar(isSeller: isSeller);
      },
      cupertino: (context, platform) {
        final isLiquidGlass = AppUtils.isiOS26OrAbove();

        return isLiquidGlass ? GlassNavBar(isSeller: isSeller) : CustomBottomNavigationBar(isSeller: isSeller);
      },
    );
  }
}


class GlassNavBar extends StatelessWidget {
  const GlassNavBar({super.key, this.isSeller = false});

  final bool isSeller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBarCubit, NavigationBarState>(
      builder: (context, state) {
        return CNTabBar(
          tint: Colors.blue.shade700,
          split: true,
          items: isSeller
              ? const [
                  CNTabBarItem(
                    icon: CNSymbol("square.grid.2x2"),
                    label: "Dashboard",
                  ),
                  CNTabBarItem(
                    icon: CNSymbol("calendar"),
                    label: "Upcoming",
                  ),
                  CNTabBarItem(
                    icon: CNSymbol("ellipsis.message"),
                    label: "Inbox",
                  ),
                  CNTabBarItem(
                    icon: CNSymbol("person"),
                  ),
                ]
              : const [
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
  const CustomBottomNavigationBar({super.key, this.isSeller = false});

  final bool isSeller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBarCubit, NavigationBarState>(
      builder: (context, state) {
        final currentIndex = state.index;
        final unreadCount = state.unReadChatCount;
        
        return Container(
          padding: const EdgeInsets.only(top: 12, bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (!isSeller) ...[
                _buildNavItem(context, 0, Icons.directions_car, "Cars", currentIndex),
                _buildNavItem(context, 1, Icons.calendar_month_outlined, "Bookings", currentIndex),
                _buildNavItem(
                  context,
                  2,
                  Icons.chat_bubble_outline,
                  "Chat",
                  currentIndex,
                  badgeCount: unreadCount,
                ),
                _buildNavItem(context, 3, Icons.person_outline, "Profile", currentIndex),
              ] else ...[
                _buildNavItem(context, 0, Icons.dashboard_outlined, "Dashboard", currentIndex),
                _buildNavItem(context, 1, Icons.directions_car, "My Cars", currentIndex),
                _buildNavItem(
                  context,
                  2,
                  Icons.chat_bubble_outline,
                  "Inbox",
                  currentIndex,
                  badgeCount: unreadCount,
                ),
                _buildNavItem(context, 3, Icons.person_outline, "Profile", currentIndex),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData icon,
    String label,
    int currentIndex, {
    int badgeCount = 0,
  }) {
    final isSelected = index == currentIndex;
    final showBadge = index == 2 && badgeCount > 0;
    final badgeText = badgeCount > 99 ? "99+" : badgeCount.toString();

    final iconBase = Icon(
      icon,
      color: isSelected ? Colors.black : Colors.grey.shade400,
      size: 26,
    );

    final iconWidget = showBadge
        ? Badge(
            backgroundColor: AppColors.primary,
            alignment: Alignment.topRight,
            offset: const Offset(8, -6),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            label: Text(
              badgeText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: iconBase,
          )
        : iconBase;
    
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
          iconWidget,
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
