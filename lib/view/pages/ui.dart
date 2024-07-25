import 'package:flutter/material.dart';

class CurvyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at the top-left corner
    path.lineTo(0, size.height);

    // Draw a line to the bottom-right corner
    path.lineTo(size.width, size.height);

    // Draw a curve to the top-right corner
    final curveStart = Offset(size.width / 2, size.height);
    final curveEnd =
        Offset(size.width / 2, size.height - 50); // Adjust curve height
    path.quadraticBezierTo(
        curveStart.dx, curveStart.dy, curveEnd.dx, curveEnd.dy);

    // Close the path
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CurvyClipper oldClipper) => false;
}
