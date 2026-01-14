import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:car_rental_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.label, this.isLiquidGlass = false,required this.onPressed, this.backgroundColor, this.foregroundColor,this.imagePath,this.isDense = false, this.liquidGlassStyle,this.padding,this.liquidGlassSize,this.liquidGlasMinimumSize,this.useSmoothRectangleBorder = true,this.isLoading = false,this.loadingColor, this.loadingIndicatorSize = const Size(24,24)});

  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? imagePath;
  final bool isDense;
  final bool isLiquidGlass;
  final EdgeInsetsGeometry? padding;
  final AdaptiveButtonSize? liquidGlassSize;
  final Size? liquidGlasMinimumSize;
  final AdaptiveButtonStyle? liquidGlassStyle;
  final bool useSmoothRectangleBorder;
  final bool isLoading;
  final Color? loadingColor;
  final Size loadingIndicatorSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            alignment: Alignment.center,
            fit: StackFit.passthrough,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        child: isLiquidGlass ? (imagePath != null || isLoading) ?  

     
        AdaptiveButton.child(
          key: ValueKey("liquid-child-$isLoading"),
          onPressed: onPressed,
          color: backgroundColor ?? AppColors.primary,
          padding: padding,
          minSize: liquidGlasMinimumSize,
          size: liquidGlassSize ?? AdaptiveButtonSize.medium,
          style:  liquidGlassStyle != null && liquidGlassStyle == AdaptiveButtonStyle.prominentGlass  && !PlatformInfo.isIOS26OrHigher() ? AdaptiveButtonStyle.filled : liquidGlassStyle ?? AdaptiveButtonStyle.filled,
          useSmoothRectangleBorder: useSmoothRectangleBorder,
          child: isLoading ? SizedBox(
            width: loadingIndicatorSize.width,
            height: loadingIndicatorSize.height,
            child: CircularProgressIndicator(color: loadingColor ?? Colors.white,strokeWidth: 2,)) : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(imagePath!,width: 18,height: 18,fit: BoxFit.cover,color: Colors.white,),
                    const SizedBox(width: 8,),
                    Text(label, style: TextStyle(color: foregroundColor),)
                  ],
                 )
        )
    :
      AdaptiveButton(
        key: ValueKey("liquid-text-$isLoading"),
        onPressed: onPressed,
        label: label,
        color: backgroundColor ?? AppColors.primary,
        textColor: foregroundColor ?? Colors.white,
        padding: padding,
        minSize: liquidGlasMinimumSize,
        size: liquidGlassSize ?? AdaptiveButtonSize.medium,
        style:  liquidGlassStyle != null && liquidGlassStyle == AdaptiveButtonStyle.prominentGlass  && !PlatformInfo.isIOS26OrHigher() ? AdaptiveButtonStyle.filled : liquidGlassStyle ?? AdaptiveButtonStyle.filled,
        useSmoothRectangleBorder: useSmoothRectangleBorder,
      )
     : PlatformElevatedButton(
      key: ValueKey("notLiquid-text-$isLoading"),
      padding: isDense ? EdgeInsets.zero : null,
      onPressed: onPressed,
       child: isLoading ? SizedBox(
            width: loadingIndicatorSize.width,
            height: loadingIndicatorSize.height,
            child: CircularProgressIndicator(color: loadingColor ?? Colors.white,strokeWidth: 2,)) : 
    imagePath != null ? 
       Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath!,width: 18,height: 18,fit: BoxFit.cover,color: Colors.white,),
          const SizedBox(width: 8,),
          Text(label, style: TextStyle(color: foregroundColor),)
        ],
       ) : Text(label, style: TextStyle(color: foregroundColor),),
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
     )
       );
  }
}
