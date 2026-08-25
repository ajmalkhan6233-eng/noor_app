// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Rebuilt fresh (2026-08-25 live-device review) rather than patched —
// the previous version's octagonal bezel (canvas.drawShadow +
// MaskFilter.blur + shader gradients, all in one CustomPainter) was
// rendering as almost nothing but the fixed-size Kaaba marker on the
// live device: confirmed via cropped/zoomed screenshots that the
// bezel, face, ticks, and needle simply weren't appearing, at any
// zoom level, while the one absolute-sized element kept painting
// fine. That points at a specific canvas op silently failing on this
// device's GPU/Skia build rather than a layout or sizing bug (layout
// was verified correct: the marker sits where a correctly-sized
// widget's center would put it). Rather than keep guessing which
// call is the culprit, the metal bezel and recessed face are now
// plain Container/BoxDecoration gradients + BoxShadow — framework-
// level, not raw canvas shaders — and this painter is left with only
// the simple primitives (lines, filled paths, text) least likely to
// hit the same wall.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'compass_ticks.dart';

class CompassFacePainter extends CustomPainter {
  CompassFacePainter({
    required this.rotationDegrees,
    required this.needleAlpha,
  });

  final double rotationDegrees;

  /// Eased toward 1.0 (trustworthy) or 0.35 (low confidence) by
  /// QiblaNeedle's AnimationController.
  final double needleAlpha;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final faceRadius = size.width / 2;

    paintCompassTicksAndLabels(canvas, center, faceRadius);
    _paintKaabaMarker(canvas, center, faceRadius);
    _paintNeedle(canvas, center, faceRadius);

    canvas.drawCircle(center, 4, Paint()..color = AppColors.ink);
  }

  void _paintKaabaMarker(Canvas canvas, Offset center, double faceRadius) {
    final pos = center + const Offset(0, -1) * (faceRadius * 0.42);
    final rect = Rect.fromCenter(center: pos, width: 10, height: 10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      Paint()..color = AppColors.gold,
    );
  }

  void _paintNeedle(Canvas canvas, Offset center, double faceRadius) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationDegrees * math.pi / 180);

    final length = faceRadius * 0.85;
    final northHalf = Path()
      ..moveTo(0, -length)
      ..lineTo(length * 0.13, length * 0.08)
      ..lineTo(0, 0)
      ..lineTo(-length * 0.13, length * 0.08)
      ..close();
    final southHalf = Path()
      ..moveTo(0, 0)
      ..lineTo(length * 0.09, length * 0.08)
      ..lineTo(0, length * 0.28)
      ..lineTo(-length * 0.09, length * 0.08)
      ..close();

    canvas.drawPath(
      northHalf,
      Paint()..color = AppColors.accentSecondary.withValues(alpha: needleAlpha),
    );
    canvas.drawPath(
      southHalf,
      Paint()..color = AppColors.sage.withValues(alpha: needleAlpha * 0.8),
    );
    canvas.drawCircle(Offset.zero, 5, Paint()..color = AppColors.ink);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CompassFacePainter oldDelegate) =>
      oldDelegate.rotationDegrees != rotationDegrees ||
      oldDelegate.needleAlpha != needleAlpha;
}
