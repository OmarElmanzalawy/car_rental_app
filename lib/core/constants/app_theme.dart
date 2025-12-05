import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background
    )
    // surfaceColor: AppColors.surface,
  );
}