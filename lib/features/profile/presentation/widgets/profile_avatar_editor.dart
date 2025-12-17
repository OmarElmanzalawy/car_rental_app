import 'dart:ui';
import 'package:car_rental_app/features/profile/presentation/customer/blocs/cubit/customer_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ProfileAvatarEditor extends StatelessWidget {
  const ProfileAvatarEditor({super.key,this.imageUrl, this.isFetchingProfilePicture = false});

  final String? imageUrl;
  final bool isFetchingProfilePicture;

  @override
  Widget build(BuildContext context) {
    return isFetchingProfilePicture ? 
      Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: CircleAvatar(
          radius: 70,
        ),
        )
    : Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : const AssetImage("assets/images/profile.jpg") as ImageProvider,
        ),
        Positioned(
          right: 8,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: GestureDetector(
              onTap: () async{
                final image = await context.read<CustomerProfileCubit>().selectProfilePicture();
                if (image != null) {
                  context.read<CustomerProfileCubit>().updateProfilePicture(image);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.45),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
