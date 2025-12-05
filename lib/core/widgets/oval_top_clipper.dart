import 'package:flutter/material.dart';

/// Clip widget in oval shape at top side
class OvalTopBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, 15);
    path.quadraticBezierTo(size.width / 7, 0, size.width / 2, 0);
    path.quadraticBezierTo(size.width - size.width / 7, 0, size.width, 15);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}