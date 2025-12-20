import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/home/domain/entities/car_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompactCarCard extends StatelessWidget {
  const CompactCarCard({
    super.key,
    required this.model,
  });

  final CarModel model;

  @override
  Widget build(BuildContext context) {
    final logoPath = "assets/logos/${model.brand.toLowerCase()}.png";
    final rawImage =
        (model.images?.isNotEmpty ?? false) ? model.images!.first : null;
    return GestureDetector(
      onTap: () => context.push(AppRoutes.carDetail,extra: model),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 190,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 10,
                spreadRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const SizedBox(height: 12),
              Expanded(
                child: Container(
                  // color: Colors.red,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Image.asset(
                          logoPath,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 40,
                              height: 40,
                            );
                          },
                        ),
                        ),
                        Positioned(
                          top: 15,
                          right: 15,
                          child: RichText(
                            text: TextSpan(
                              text: "\$${model.pricePerDay.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                              children: [
                                TextSpan(
                                  text: "\n/day",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
      
                          ),
                      Positioned(
                        top: 30,
                        left: 0,
                        child: Container(
                          // color: Colors.orange,
                          child: (rawImage != null && rawImage.startsWith('http'))
                              ? CachedNetworkImage(
                                  imageUrl: rawImage,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url, progress) {
                                    return Center(
                                      child: CircularProgressIndicator.adaptive(
                                        value: progress.progress,
                                      ),
                                    );
                                  },
                                  errorWidget: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/icons/car_placeholder.png",
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/icons/car_placeholder.png",
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Details",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          color: AppColors.primary
                        ),
                        child: Row(
                          children: [
                            Text("Rent now",style: TextStyle(color: Colors.white,fontSize: 14),),
                            const SizedBox(width: 5,),
                            Icon(Icons.arrow_forward,color: Colors.white,size: 16,),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
