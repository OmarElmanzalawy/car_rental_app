import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';

class ProfileAvatarEditor extends StatelessWidget {
  const ProfileAvatarEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const CircleAvatar(
          radius: 70,
          backgroundImage: AssetImage("assets/images/profile.jpg"),
        ),
        Positioned(
          right: 8,
          bottom: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 22),
            ),
          ),
        ),
      ],
    );
  }
}
