// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Paints the compass as a physical object: a raised bezel (gradient +
// drop shadow), a recessed face (an inset-shadow ring at its rim),
// hairline degree ticks, cardinal labels, and a gradient-filled
// needle that casts its own soft shadow onto the face beneath it via
// Canvas.drawShadow.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'compass_ticks.dart';

class CompassFacePainter extends CustomPainter {
  CompassFacePainter({required this.rotationDegrees, required this.dimmed});

  final double rotationDegrees;
  final bool dimmed;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    _paintBezel(canvas, center, radius);
    final faceRadius = radius * 0.82;
    _paintRecessedFace(canvas, center, faceRadius);
    paintCompassTicksAndLabels(canvas, center, faceRadius);
    _paintNeedle(canvas, center, faceRadius);

    canvas.drawCircle(
      center,
      5,
      Paint()..color = AppColors.ink.withValues(alpha: 0.7),
    );
  }

  void _paintBezel(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(
      center + const Offset(0, 5),
      radius - 1,
      Paint()
        ..color = AppColors.ink.withValues(alpha: 0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = ui.Gradient.linear(rect.topLeft, rect.bottomRight, [
          Colors.white,
          AppColors.hairline,
        ]),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.hairline,
    );
  }

  void _paintRecessedFace(Canvas canvas, Offset center, double faceRadius) {
    canvas.drawCircle(center, faceRadius, Paint()..color = AppColors.paper);
    canvas.drawCircle(
      center,
      faceRadius,
      Paint()
        ..shader = ui.Gradient.radial(
          center,
          faceRadius,
          [Colors.transparent, AppColors.ink.withValues(alpha: 0.12)],
          const [0.82, 1.0],
        ),
    );
  }

  void _paintNeedle(Canvas canvas, Offset center, double faceRadius) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationDegrees * math.pi / 180);

    final length = faceRadius * 0.85;
    final path = Path()
      ..moveTo(0, -length)
      ..lineTo(length * 0.13, length * 0.25)
      ..lineTo(0, length * 0.12)
      ..lineTo(-length * 0.13, length * 0.25)
      ..close();

    if (!dimmed) {
      canvas.save();
      canvas.translate(2.5, 3.5);
      canvas.drawShadow(path, AppColors.ink, 3, false);
      canvas.restore();
    }

    final alpha = dimmed ? 0.35 : 1.0;
    final rect = path.getBounds();
    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(rect.topCenter, rect.bottomCenter, [
          AppColors.emerald.withValues(alpha: alpha),
          AppColors.emerald.withValues(alpha: alpha * 0.7),
        ]),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CompassFacePainter oldDelegate) =>
      oldDelegate.rotationDegrees != rotationDegrees ||
      oldDelegate.dimmed != dimmed;
}
