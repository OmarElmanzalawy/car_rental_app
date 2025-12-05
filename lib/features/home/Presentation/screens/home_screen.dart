import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/widgets/oval_top_clipper.dart';
import 'package:car_rental_app/features/home/Presentation/bloc/cubit/navigation_bar_cubit.dart';
import 'package:car_rental_app/features/home/Presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:car_rental_app/features/home/Presentation/widgets/glass_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBarCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<NavigationBarCubit, NavigationBarState>(
              builder: (context, state) {
                return IndexedStack(
                  index: state.index,
                  children: [
                    const _HomeContent(),
                    const Center(child: Text("Cars Screen")),
                    const Center(child: Text("Maps Screen")),
                    const Center(child: Text("User Screen")),
                  ],
                );
              },
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                height: size.height * 0.338,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.45, 1.0],
                    colors: [
                      Colors.blue.shade800,
                      Colors.black,
                      Colors.blue.shade800,
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
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.background,
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
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
                                barBackgroundColor: const WidgetStatePropertyAll(
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
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.background,
                              ),
                              child: const Icon(Icons.tune, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 28,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => const GlassCapsule(),
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
                bottom: 0,
                child: ClipPath(
                  clipper: OvalTopBorderClipper(),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.71,
                    color: AppColors.background,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30,),
                          Text("Top Deals", style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              // color: Colors.red
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
