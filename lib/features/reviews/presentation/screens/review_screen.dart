import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: Material(
        child: Container(
          child: Center(
            child: Text("Reviews Screen"),
          ),
        ),
      ),
    );
  }
}