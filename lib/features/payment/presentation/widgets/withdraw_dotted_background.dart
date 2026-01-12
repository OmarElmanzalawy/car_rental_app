import 'dart:math' as math;

import 'package:flutter/material.dart';

class WithdrawDottedBackground extends StatelessWidget {
  const WithdrawDottedBackground({
    super.key,
    required this.child,
    this.dotColor = Colors.white,
    this.dotOpacity = 0.12,
    this.dotRadius = 2.0,
    this.spacing = 26.0,
  });

  final Widget child;
  final Color dotColor;
  final double dotOpacity;
  final double dotRadius;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DotsPainter(
        dotColor: dotColor,
        dotOpacity: dotOpacity,
        dotRadius: dotRadius,
        spacing: spacing,
      ),
      child: child,
    );
  }
}

class _DotsPainter extends CustomPainter {
  const _DotsPainter({
    required this.dotColor,
    required this.dotOpacity,
    required this.dotRadius,
    required this.spacing,
  });

  final Color dotColor;
  final double dotOpacity;
  final double dotRadius;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor.withValues(alpha: dotOpacity)
      ..style = PaintingStyle.fill;

    for (double y = -spacing; y <= size.height + spacing; y += spacing) {
      final rowShift = (y / spacing).floor().isEven ? 0.0 : spacing / 2;
      for (double x = -spacing; x <= size.width + spacing; x += spacing) {
        final dx = x + rowShift;
        final dy = y + (math.sin((x + y) * 0.02) * 2.0);
        canvas.drawCircle(Offset(dx, dy), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotsPainter oldDelegate) {
    return oldDelegate.dotColor != dotColor ||
        oldDelegate.dotOpacity != dotOpacity ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.spacing != spacing;
  }
}
