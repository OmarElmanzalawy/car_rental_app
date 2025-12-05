import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/widgets/oval_bottom_clipper.dart';
import 'package:car_rental_app/core/widgets/oval_top_clipper.dart';
import 'package:car_rental_app/features/home/Presentation/widgets/glass_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
                children: [
                Container(
                  height: size.height * 0.338,
                  width: size.width,
                  // color: Colors.red,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.45, 1.0],
                      colors: [
                        Colors.blue.shade800,
                        Colors.black,
                        Colors.blue.shade800
                      ],
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 55,),
                        Row(
                          children: [
                            Text(
                              "Available rides",
                              style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.background
                                  ),
                                  child: Icon(Icons.notifications_outlined,color: Colors.black,size: 20,),
                                ),
                              )
                          ],
                        ),
                          const SizedBox(height: 30,),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: SearchAnchor.bar(
                                    barHintText: "Search for a ride",
                                    viewBackgroundColor: AppColors.background,
                                    viewLeading: IconButton(onPressed: () {
                                      context.pop();
                                    },
                                     icon: Icon(Icons.arrow_back_ios),color: Colors.black,),
                                    barBackgroundColor: WidgetStatePropertyAll(AppColors.background),
                                    barLeading: Icon(Icons.search,color: Colors.black,),
                                    isFullScreen: false,
                                    suggestionsBuilder:(context, controller) {
                                      return [];
                                    },
                                    ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              InkWell(
                                onTap: () {
                                  
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.background
                                  ),
                                  child: Icon(Icons.tune,color: Colors.black,),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.purple,
                              child: ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(width: 10,),
                                scrollDirection: Axis.horizontal,
                                itemCount: 7,
                                itemBuilder:(context, index) {
                                  return GlassCapsule();
                                }
                              ),
                            ),
                          )
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
                      height: size.height * 0.72,
                      color: AppColors.background,
                    ),
                  ),
                )
                ]
              ),
          ),
          
        ],
      )
    );
  }
}