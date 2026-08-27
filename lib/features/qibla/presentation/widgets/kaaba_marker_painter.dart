// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The fixed marker at the top of the compass face showing where the
// Kaaba direction is measured from — previously a plain gold rounded
// square, which read as an abstract UI dot rather than the Kaaba
// itself (direct feedback: "put the cover on the middle of the
// compass" — the kiswah, the Kaaba's black-and-gold cloth covering).
// Redrawn as a small cube with its kiswah band and door, still plain
// canvas primitives only (paths + rects, no gradients/shaders) per
// this screen's own established constraint — see
// compass_face_painter.dart's header for why.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Draws the Kaaba marker at [center], scaled to [faceRadius], with a
/// slow ambient glow breathing at [pulse] (0..1, from QiblaNeedle's
/// looping AnimationController) — a small, deliberately subtle sign
/// of life on an otherwise static icon.
void paintKaabaMarker(Canvas canvas, Offset center, double faceRadius, double pulse) {
  final pos = center + const Offset(0, -1) * (faceRadius * 0.42);
  final cubeSize = faceRadius * 0.16;

  // Soft breathing glow behind the cube — alpha eases between two low
  // values so it never competes with the needle for attention.
  final glowAlpha = 0.12 + 0.10 * pulse;
  canvas.drawCircle(
    pos,
    cubeSize * (0.9 + 0.15 * pulse),
    Paint()
      ..color = AppColors.gold.withValues(alpha: glowAlpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
  );

  final cubeRect = Rect.fromCenter(center: pos, width: cubeSize, height: cubeSize);
  final cubeRRect = RRect.fromRectAndRadius(cubeRect, Radius.circular(cubeSize * 0.12));

  // Cube body — the Kaaba's black stone structure.
  canvas.drawRRect(cubeRRect, Paint()..color = AppColors.ink);

  // Kiswah band — the gold-embroidered strip near the top third.
  final bandRect = Rect.fromLTWH(
    cubeRect.left,
    cubeRect.top + cubeSize * 0.28,
    cubeSize,
    cubeSize * 0.16,
  );
  canvas.drawRect(bandRect, Paint()..color = AppColors.gold);

  // A hairline door accent, off-center, just below the band.
  final doorRect = Rect.fromLTWH(
    cubeRect.left + cubeSize * 0.42,
    bandRect.bottom + cubeSize * 0.08,
    cubeSize * 0.16,
    cubeSize * 0.34,
  );
  canvas.drawRect(doorRect, Paint()..color = AppColors.gold.withValues(alpha: 0.85));

  canvas.drawRRect(
    cubeRRect,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.gold.withValues(alpha: 0.6),
  );
}
