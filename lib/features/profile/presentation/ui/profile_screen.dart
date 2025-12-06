import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:car_rental_app/core/constants/app_routes.dart';
import 'package:car_rental_app/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AdaptiveScaffold(
      body: Center(
        child: AdaptiveButton(
          style: AdaptiveButtonStyle.prominentGlass,
          textColor: Colors.white,
          minSize: Size(size.width * 0.35, 40),
          color: AppColors.primary,
          onPressed: ()async{
            final response = await AuthService.signOut();
            if(response.success){
              context.go(AppRoutes.login);
            }else{
              
            }
          },
          label: "Log out"
          ),
      ),
    );
  }
}