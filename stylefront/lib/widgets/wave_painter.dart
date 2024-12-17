import 'package:flutter/material.dart';
import 'dart:math';

class WavePainter extends CustomPainter {
  final double wavePhase1;
  final double wavePhase2;

  WavePainter(this.wavePhase1, this.wavePhase2);

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the main wave
    final Paint paintMain = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue.shade800,
          Colors.blue.shade400,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Paint for the layered wave
    final Paint paintLayer = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.blue.shade600.withOpacity(0.6),
          Colors.blue.shade200.withOpacity(0.6),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    Path pathMain = Path();
    Path pathLayer = Path();

    // Main wave with 1.5 cycles
    pathMain.moveTo(0, size.height * 0.35);
    for (double i = 0; i <= size.width; i++) {
      double y = size.height * 0.35 +
          20 * sin((i / size.width * 2 * pi * 1.5) + wavePhase1);
      pathMain.lineTo(i, y);
    }
    pathMain.lineTo(size.width, 0);
    pathMain.lineTo(0, 0);
    pathMain.close();

    // Layered wave with 1.5 cycles
    pathLayer.moveTo(0, size.height * 0.4);
    for (double i = 0; i <= size.width; i++) {
      double y = size.height * 0.4 +
          15 * sin((i / size.width * 2 * pi * 1.5) + wavePhase2);
      pathLayer.lineTo(i, y);
    }
    pathLayer.lineTo(size.width, 0);
    pathLayer.lineTo(0, 0);
    pathLayer.close();

    // Draw layered wave first for depth effect
    canvas.drawPath(pathLayer, paintLayer);
    // Draw main wave on top
    canvas.drawPath(pathMain, paintMain);

    // Add splash elements on the wave
    _drawSplashElements(canvas, size);
  }

  void _drawSplashElements(Canvas canvas, Size size) {
    final Paint splashPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Example splash elements
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.3), 10, splashPaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.4), 15, splashPaint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), 8, splashPaint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.wavePhase1 != wavePhase1 ||
           oldDelegate.wavePhase2 != wavePhase2;
  }
}