import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

class Capsule extends StatelessWidget {
  Capsule({super.key,required this.text,this.isGlass = true,this.backgroundColor,this.textColor});

  final String text;
  final bool isGlass;
  Color? backgroundColor;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isGlass ? backgroundColor?.withOpacity(0.2) ?? Colors.grey.shade200.withOpacity(0.2) : backgroundColor ?? Colors.grey.shade200
      ),
      child: Text(text,style: TextStyle(color: textColor ?? Colors.white),),
    );
  }
}