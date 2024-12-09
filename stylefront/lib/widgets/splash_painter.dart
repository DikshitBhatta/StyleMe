import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashPainter extends CustomPainter {
  final double animationValue;
  final Color color;
  final Offset center;

  SplashPainter({
    required this.animationValue,
    required this.color,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height);
    final radius = maxRadius * animationValue;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(SplashPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.color != color ||
           oldDelegate.center != center;
  }
}