import 'package:flutter/material.dart';

class GlassCapsule extends StatelessWidget {
  const GlassCapsule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey.shade200.withOpacity(0.2)
      ),
      child: Text("Mercedes",style: TextStyle(color: Colors.white),),
    );
  }
}