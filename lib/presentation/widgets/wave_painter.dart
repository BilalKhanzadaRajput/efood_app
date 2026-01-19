import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class WavePainter extends CustomPainter {
  final double waveOffset;

  WavePainter({required this.waveOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Deep red base wave (lowest layer)
    paint.color = AppColors.deepRed;
    final deepWavePath = Path();
    deepWavePath.moveTo(0, size.height * 0.6);

    for (double x = 0; x <= size.width; x += 2) {
      final y = size.height * 0.6 +
          math.sin((x / size.width * 4 * math.pi) + waveOffset) * 35;
      deepWavePath.lineTo(x, y);
    }
    deepWavePath.lineTo(size.width, size.height);
    deepWavePath.lineTo(0, size.height);
    deepWavePath.close();

    canvas.drawPath(deepWavePath, paint);

    // Semi-transparent lighter red wave (middle layer)
    paint.color = AppColors.lightRed.withOpacity(0.7);
    final middleWavePath = Path();
    middleWavePath.moveTo(0, size.height * 0.5);

    for (double x = 0; x <= size.width; x += 2) {
      final y = size.height * 0.5 +
          math.sin((x / size.width * 4 * math.pi) + waveOffset + 0.5) * 30;
      middleWavePath.lineTo(x, y);
    }
    middleWavePath.lineTo(size.width, size.height * 0.6);
    middleWavePath.lineTo(0, size.height * 0.6);
    middleWavePath.close();

    canvas.drawPath(middleWavePath, paint);

    // Top semi-transparent wave (top layer)
    paint.color = AppColors.lightRed.withOpacity(0.5);
    final topWavePath = Path();
    topWavePath.moveTo(0, size.height * 0.4);

    for (double x = 0; x <= size.width; x += 2) {
      final y = size.height * 0.4 +
          math.sin((x / size.width * 4 * math.pi) + waveOffset + 1.0) * 25;
      topWavePath.lineTo(x, y);
    }
    topWavePath.lineTo(size.width, size.height * 0.5);
    topWavePath.lineTo(0, size.height * 0.5);
    topWavePath.close();

    canvas.drawPath(topWavePath, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) =>
      oldDelegate.waveOffset != waveOffset;
}
