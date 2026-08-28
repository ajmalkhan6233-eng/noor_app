// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Kaaba marker — previously a fixed icon near the top of the
// compass face, entirely separate from the needle (direct feedback,
// 2026-08-28 live-device review: "should be positioned directly on
// the needle itself, not separate from it"). Now painted at the
// needle's own tip, inside the same rotated canvas context the needle
// draws in, so it moves and turns with it. Also switched from a
// light/near-white cube body (AppColorTokens.cosmic.ink, which does NOT read as
// black despite the old comment claiming it did) to genuine black, per
// direct instruction to match the real Kaaba's kiswah color.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';

const _kaabaBlack = Color(0xFF0A0A0A);

/// Draws the Kaaba marker centered at the local origin — call this
/// after translating/rotating the canvas to the needle's tip, so the
/// marker inherits the needle's own rotation and always points along
/// it. [size] is the marker's edge length; [pulse] (0..1, looping)
/// drives a slow ambient glow, a small deliberate sign of life.
void paintKaabaMarker(Canvas canvas, double size, double pulse) {
  const pos = Offset.zero;
  final cubeSize = size;

  // Soft breathing glow behind the cube — kept deliberately faint
  // (2026-08-28 live-device finding: at the previous 0.16-0.28 alpha
  // range, the glow visually dominated the small black cube and the
  // whole marker read as "gold", not black, defeating the point of
  // making the cube black at all).
  final glowAlpha = 0.06 + 0.05 * pulse;
  canvas.drawCircle(
    pos,
    cubeSize * (0.85 + 0.1 * pulse),
    Paint()
      ..color = AppColorTokens.cosmic.gold.withValues(alpha: glowAlpha)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
  );

  final cubeRect = Rect.fromCenter(center: pos, width: cubeSize, height: cubeSize);
  final cubeRRect = RRect.fromRectAndRadius(cubeRect, Radius.circular(cubeSize * 0.12));

  // Cube body — the Kaaba's black stone structure, genuinely black.
  canvas.drawRRect(cubeRRect, Paint()..color = _kaabaBlack);

  // Kiswah band — the gold-embroidered strip near the top third.
  final bandRect = Rect.fromLTWH(
    cubeRect.left,
    cubeRect.top + cubeSize * 0.28,
    cubeSize,
    cubeSize * 0.16,
  );
  canvas.drawRect(bandRect, Paint()..color = AppColorTokens.cosmic.gold);

  // A hairline door accent, off-center, just below the band.
  final doorRect = Rect.fromLTWH(
    cubeRect.left + cubeSize * 0.42,
    bandRect.bottom + cubeSize * 0.08,
    cubeSize * 0.16,
    cubeSize * 0.34,
  );
  canvas.drawRect(doorRect, Paint()..color = AppColorTokens.cosmic.gold.withValues(alpha: 0.85));

  canvas.drawRRect(
    cubeRRect,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColorTokens.cosmic.gold.withValues(alpha: 0.7),
  );
}
