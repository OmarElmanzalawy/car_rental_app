import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.label, this.isLiquidGlass = false,required this.onPressed, this.backgroundColor, this.foregroundColor,this.imagePath,this.isDense = false, this.liquidGlassStyle,this.padding,this.liquidGlassSize});

  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? imagePath;
  final bool isDense;
  final bool isLiquidGlass;
  final EdgeInsetsGeometry? padding;
  final AdaptiveButtonSize? liquidGlassSize;

  final AdaptiveButtonStyle? liquidGlassStyle;
  

  @override
  Widget build(BuildContext context) {
    return  isLiquidGlass ?
      AdaptiveButton(
        onPressed: onPressed,
        label: label,
        color: backgroundColor ?? AppColors.primary,
        textColor: foregroundColor ?? Colors.white,
        padding: padding,
        size: liquidGlassSize ?? AdaptiveButtonSize.medium,
        style: liquidGlassStyle ?? AdaptiveButtonStyle.filled,
      )
     : PlatformElevatedButton(
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
          padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          ),
        ),
        cupertino: (context, platform) => CupertinoElevatedButtonData(
          borderRadius: BorderRadius.circular(25),
          padding: padding,
        ),
       );
  }
}