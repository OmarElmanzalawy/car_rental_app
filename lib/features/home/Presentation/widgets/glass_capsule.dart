import 'package:flutter/material.dart';

class GlassCapsule extends StatelessWidget {
  const GlassCapsule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.red.withOpacity(0.8)
      ),
      child: Text("Mercedes",style: TextStyle(color: Colors.white),),
    );
  }
}