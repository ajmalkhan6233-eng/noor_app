// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Degree ticks, cardinal/intercardinal labels, and a decorative inner
// rosette for the compass face — split out of CompassFacePainter to
// stay under the 150-line limit.
//
// Rebuilt from scratch (2026-08-28 live-device review: "looks too
// simple — like a watch, not a compass" — the previous version drew
// only 12 ticks at 30° spacing with no graduation at all). Now a full
// 5°-graduated ring (72 ticks: minor every 5°, medium every 15°, major
// every 30°, longest+boldest at the four cardinals) plus an 8-point
// rosette star behind the ticks for real visual density, still using
// only plain lines/paths/text — no shaders/gradients, per this
// screen's established GPU-safety constraint (see
// compass_face_painter.dart's header for why that constraint exists).

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

void paintCompassTicksAndLabels(
  Canvas canvas,
  Offset center,
  double faceRadius,
) {
  _paintRosette(canvas, center, faceRadius);
  _paintTickRing(canvas, center, faceRadius);
  _paintCardinalLabels(canvas, center, faceRadius);
}

/// An 8-point star traced behind the ticks — a fixed ornamental motif
/// (not tied to compass heading), giving the face real depth instead
/// of reading as a flat clock.
void _paintRosette(Canvas canvas, Offset center, double faceRadius) {
  final outer = faceRadius * 0.62;
  final inner = faceRadius * 0.30;
  final path = Path();
  for (var i = 0; i < 16; i++) {
    final radius = i.isEven ? outer : inner;
    final angle = i * (math.pi / 8);
    final point = center + Offset(math.sin(angle), -math.cos(angle)) * radius;
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  canvas.drawPath(
    path,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.accentSecondary.withValues(alpha: 0.18),
  );
}

void _paintTickRing(Canvas canvas, Offset center, double faceRadius) {
  for (var deg = 0; deg < 360; deg += 5) {
    final angle = deg * math.pi / 180;
    final direction = Offset(math.sin(angle), -math.cos(angle));
    final isCardinal = deg % 90 == 0;
    final isMajor = deg % 30 == 0;
    final isMedium = deg % 15 == 0;
    final innerStop = isCardinal
        ? 0.74
        : isMajor
            ? 0.80
            : isMedium
                ? 0.85
                : 0.89;
    canvas.drawLine(
      center + direction * (faceRadius * innerStop),
      center + direction * (faceRadius * 0.95),
      Paint()
        ..color = isCardinal
            ? AppColors.gold.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: isMajor ? 0.75 : 0.4)
        ..strokeWidth = isCardinal
            ? 2
            : isMajor
                ? 1.4
                : 0.6,
    );

    // Degree numerals at every major tick (every 30°) for real
    // instrument detail, skipping the cardinals since they get their
    // own N/E/S/W letters instead.
    if (isMajor && !isCardinal) {
      final numeralPos = center + direction * (faceRadius * 0.68);
      _drawText(canvas, numeralPos, '$deg', size: 9, color: AppColors.sage);
    }
  }
}

void _paintCardinalLabels(Canvas canvas, Offset center, double faceRadius) {
  const labels = ['N', 'E', 'S', 'W'];
  for (var i = 0; i < 4; i++) {
    final angle = i * 90 * math.pi / 180;
    final pos =
        center + Offset(math.sin(angle), -math.cos(angle)) * (faceRadius * 0.60);
    _drawText(
      canvas,
      pos,
      labels[i],
      size: i == 0 ? 16 : 14,
      color: i == 0 ? AppColors.gold : AppColors.ink,
      weight: i == 0 ? FontWeight.w700 : FontWeight.w600,
    );
  }

  const intercardinals = ['NE', 'SE', 'SW', 'NW'];
  for (var i = 0; i < 4; i++) {
    final angle = (45 + i * 90) * math.pi / 180;
    final pos =
        center + Offset(math.sin(angle), -math.cos(angle)) * (faceRadius * 0.66);
    _drawText(canvas, pos, intercardinals[i], size: 9, color: AppColors.sage);
  }
}

void _drawText(
  Canvas canvas,
  Offset center,
  String text, {
  required double size,
  required Color color,
  FontWeight weight = FontWeight.w500,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: AppTypography.bodyFamily,
        fontWeight: weight,
        fontSize: size,
        color: color,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
}
