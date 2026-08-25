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
//
// Update (2026-08-25, same day, later): the plain-primitives version
// above still intermittently "blinks" on this same device — confirmed
// with 10-shot rapid screenshot sequences and pixel-sampling (not just
// eyeballing): in the bad frames, the pixels where the circle
// Container and CompassFacePainter's ticks/needle should be read as
// pure AppColors.paper (the screen background), not a dim or partial
// render — the whole subtree is simply absent from that composited
// frame, while only the 10x10 Kaaba marker rect still paints. Two
// standard mitigations were tried and BOTH made it worse, not better:
//   1. RepaintBoundary around the needle/circle Stack, then around the
//      whole DraggableFloating subtree (outside its Transform.scale) —
//      went from ~50% bad frames to ~93% bad, often getting stuck
//      permanently on the marker-only state instead of recovering.
//   2. Throttling QiblaCubit's emit to 80ms (reducing how often this
//      painter repaints, since the raw magnetometer stream can fire
//      much faster than the display) — same result, mostly stuck.
// Both changes reduce how often the tree gets a full rebuild/repaint;
// both made the bug more persistent. That's a real clue (something
// about frequent full rebuilds seems to be what makes the correct
// frame show up at all) but not something to act on blind — don't
// retry either mitigation without a connected device to verify
// against. Reverted both; this file is back to the state above.
// Root cause still unconfirmed — most likely a genuine GPU/Skia (or
// Impeller) layer-compositing bug specific to this device, not a Dart
// state bug (the underlying values were always correct).

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
