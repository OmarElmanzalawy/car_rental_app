import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.label, required this.onPressed, this.backgroundColor, this.foregroundColor,this.imagePath,this.isDense = false});

  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? imagePath;
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return PlatformElevatedButton(
      padding: isDense ? EdgeInsets.zero : null,
      onPressed: onPressed,
       child: imagePath != null ? 
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath!,width: 18,height: 18,fit: BoxFit.cover,color: Colors.white,),
          const SizedBox(width: 8,),
          Text(label)
        ],
       ) : Text(label),
       color: backgroundColor ?? AppColors.primary,
        material: (context, platform) => MaterialElevatedButtonData(
          style: ElevatedButton.styleFrom(
            foregroundColor: foregroundColor ?? Colors.white,
          backgroundColor: backgroundColor ?? AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          ),
        ),
        cupertino: (context, platform) => CupertinoElevatedButtonData(
          borderRadius: BorderRadius.circular(25),
        ),
       );
  }
}