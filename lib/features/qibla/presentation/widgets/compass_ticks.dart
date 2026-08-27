// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Degree ticks and N/E/S/W cardinal labels for the compass face —
// split out of CompassFacePainter to stay under the 150-line limit.
// Plain solid-color lines/text only (see compass_face_painter.dart's
// header for why the tilt-lit/shadowed variant was dropped).

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

void paintCompassTicksAndLabels(
  Canvas canvas,
  Offset center,
  double faceRadius,
) {
  for (var deg = 0; deg < 360; deg += 30) {
    final angle = deg * math.pi / 180;
    final direction = Offset(math.sin(angle), -math.cos(angle));
    canvas.drawLine(
      center + direction * (faceRadius * 0.8),
      center + direction * (faceRadius * 0.95),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.75)
        ..strokeWidth = deg % 90 == 0 ? 1.5 : 0.75,
    );
  }
  const labels = ['N', 'E', 'S', 'W'];
  for (var i = 0; i < 4; i++) {
    final angle = i * 90 * math.pi / 180;
    final pos =
        center + Offset(math.sin(angle), -math.cos(angle)) * (faceRadius * 0.66);
    _drawLabel(canvas, pos, labels[i], bold: i == 0);
  }
}

void _drawLabel(Canvas canvas, Offset center, String text, {bool bold = false}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: AppTypography.bodyFamily,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        fontSize: bold ? 15 : 13,
        color: bold ? AppColors.gold : AppColors.sage,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
}
