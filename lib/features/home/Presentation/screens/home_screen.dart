import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/widgets/oval_top_clipper.dart';
import 'package:car_rental_app/features/home/Presentation/blocs/nav_bar_cubit/navigation_bar_cubit.dart';
import 'package:car_rental_app/features/home/Presentation/widgets/compact_car_card.dart';
import 'package:car_rental_app/core/widgets/platform_nav_bar.dart';
import 'package:car_rental_app/features/home/Presentation/widgets/glass_capsule.dart';
import 'package:car_rental_app/features/home/Presentation/widgets/large_car_card.dart';
import 'package:car_rental_app/features/profile/presentation/ui/profile_screen.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBarCubit(),
      child: AdaptiveScaffold(
        body: Stack(
          children: [
            BlocBuilder<NavigationBarCubit, NavigationBarState>(
              builder: (context, state) {
                return IndexedStack(
                  index: state.index,
                  children: [
                    _HomeContent(),
                    const Center(child: Text("Bookings Screen")),
                    const Center(child: Text("Chat Screen")),
                    ProfileScreen()
                  ],
                );
              },
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              // child: CustomBottomNavigationBar(),
              child: PlatformNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
   _HomeContent();

  List<String> testCarsImagePaths = [
    "assets/images/test_cars/bmw.jpg",
    "assets/images/test_cars/corolla_14.jpeg",
    "assets/images/test_cars/audi_a8.avif",
    // "assets/images/test_cars/mercedes.jpg",
    // "assets/images/test_cars/tesla.jpg",
  ];

  List<String> testCompactCarsImagePaths = [
    "assets/images/test_cars/tesla.png",
    "assets/images/test_cars/mustang.avif",
    "assets/images/test_cars/sclass.png",
    "assets/images/test_cars/supra.png",
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double headerHeight = size.height * 0.338;
    final double clipTop = size.height * 0.29;
    final double largeListHeight = 330;
    final double compactListHeight = 250;
    final double clipMinHeight = size.height * 1.02;
    final double stackHeight = clipTop + clipMinHeight;
    return SingleChildScrollView(
      child: SizedBox(
        height: stackHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: headerHeight,
              width: size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.45, 1.0],
                  colors: [
                    Colors.blue.shade600,
                    Colors.grey.shade900,
                    Colors.blue.shade600,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 55),
                    Row(
                      children: [
                        const Text(
                          "Available rides",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        AdaptiveButton.icon(
                          onPressed: (){},
                           icon: Icons.notifications_outlined,
                           size: AdaptiveButtonSize.small,
                           color: AppColors.primary,
                           padding: EdgeInsets.all(8),
                           iconColor: Colors.white,
                           style: AdaptiveButtonStyle.prominentGlass,
                           minSize: Size(38, 38),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: SearchAnchor.bar(
                              barHintText: "Search for a ride",
                              viewBackgroundColor: AppColors.background,
                              viewLeading: IconButton(
                                onPressed: () {
                                  context.pop();
                                },
                                icon: const Icon(Icons.arrow_back_ios),
                                color: Colors.black,
                              ),
                              barBackgroundColor:
                                  const WidgetStatePropertyAll(
                                AppColors.background,
                              ),
                              barLeading: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              isFullScreen: false,
                              suggestionsBuilder: (context, controller) {
                                return [];
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        AdaptiveButton.icon(
                          onPressed: (){},
                          icon: Icons.tune,
                          size: AdaptiveButtonSize.small,
                          color: AppColors.primary,
                          padding: EdgeInsets.all(8),
                          iconColor: Colors.white,
                          style: AdaptiveButtonStyle.tinted,
                          minSize: Size(50, 50),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 28,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Capsule(text: "Mercedes",),
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 8),
                        itemCount: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: clipTop,
              left: 0,
              right: 0,
              child: ClipPath(
                clipper: OvalTopBorderClipper(),
                child: Container(
                  width: size.width,
                  constraints: BoxConstraints(minHeight: clipMinHeight),
                  color: AppColors.background,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Top Deals",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "View all",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: compactListHeight,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: testCompactCarsImagePaths.length,
                            itemBuilder: (context, index) {
                              return CompactCarCard(
                                carImagePath: testCompactCarsImagePaths[index],
                                carName: "BMW M4 Coupe",
                                carPrice: "340",
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(width: 15),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Available Near You",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "View all",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: largeListHeight,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: testCarsImagePaths.length,
                            itemBuilder: (context, index) {
                              return LargeCarCard(
                                carImagePath: testCarsImagePaths[index],
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(width: 25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
