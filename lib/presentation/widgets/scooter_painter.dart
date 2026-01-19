import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ScooterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Scooter body (coral-red color)
    paint.color = AppColors.coralRed;
    
    // Main scooter body path
    final scooterBody = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.8, size.height * 0.5)
      ..lineTo(size.width * 0.85, size.height * 0.4)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..close();

    canvas.drawPath(scooterBody, paint);

    // Delivery box (light grey)
    paint.color = AppColors.lightGrey;
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.55,
        size.height * 0.25,
        size.width * 0.35,
        size.height * 0.25,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(boxRect, paint);

    // "eFood" text on box
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'eFood',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width * 0.55 + (size.width * 0.35 - textPainter.width) / 2,
        size.height * 0.25 + (size.height * 0.25 - textPainter.height) / 2,
      ),
    );

    // Front wheel (white with dark grey hub)
    paint.color = AppColors.white;
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.7),
      18,
      paint,
    );
    paint.color = AppColors.darkGrey;
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.7),
      8,
      paint,
    );

    // Rear wheel (white with dark grey hub)
    paint.color = AppColors.white;
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.7),
      18,
      paint,
    );
    paint.color = AppColors.darkGrey;
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.7),
      8,
      paint,
    );

    // Handlebar
    paint.color = AppColors.coralRed;
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.3),
      Offset(size.width * 0.25, size.height * 0.15),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.15),
      Offset(size.width * 0.35, size.height * 0.15),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
