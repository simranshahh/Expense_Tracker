// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class UITry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CurvyClipper(),
              child: Container(
                color: Colors.deepPurple.withOpacity(0.9),
                height: 300.0,
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors
                          .transparent, 
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: CurvyClipper(),
              child: Container(
                color: Colors.deepPurple.withOpacity(0.2),
                height: 350.0, 
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors
                          .transparent, 
                      elevation: 0, 
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: Second(),
              child: Container(
                color: Colors.deepPurple.withOpacity(0.2),
                height: 390.0, 
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors
                          .transparent, 
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: Second(),
              child: Container(
                color: Colors.deepPurple.withOpacity(0.2),
                height: 450.0, 
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors
                          .transparent, 
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 150,
            right: 0,
            child: ClipPath(
              clipper: Third(),
              child: Container(
                color: Colors.deepPurple.withOpacity(0.2),
                height: 500.0, 
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors
                          .transparent, 
                      elevation: 0, 
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: Third(),
              child: Container(
                color: Colors.deepPurple.withOpacity(0.2),
                height: 500.0, 
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: Colors
                          .transparent,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at the top-left corner
    path.lineTo(0, size.height * 0.6);

    // Draw a curve to a mid-point
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height * 0.7);

    // Draw a curve to the bottom-right corner
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height * 0.4, size.width, size.height * 0.6);

    // Close the path
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CurvyClipper oldClipper) => false;
}

class Second extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at the top-right corner
    path.lineTo(size.width, 0);

    // Draw a curve to a mid-point
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.3,
        size.width * 0.5, size.height * 0.5);

    // Draw a curve to the bottom-left corner
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.7, 0, size.height * 0.6);

    // Close the path
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(Second oldClipper) => false;
}

class Third extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at the top-right corner
    path.moveTo(size.width, 0);

    // Draw a curve to the mid-point and then to the top-left corner
    path.quadraticBezierTo(size.width * 1.5, size.height, 0, 0);

    // Close the path
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(Third oldClipper) => false;
}
