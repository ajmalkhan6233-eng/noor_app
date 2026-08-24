// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Paints the compass as a physical object: a raised dark
// titanium/obsidian bezel (gradient + drop shadow that shifts with
// device tilt) with a subtle gold metallic rim reflection, a recessed
// face (an inset-shadow ring at its rim), engraved degree ticks,
// cardinal labels, a gold Kaaba marker (the fixed landmark), and a
// cyan gradient-filled needle (the live pointer — deliberately a
// different locked token than the marker so the two aren't the same
// colour) that casts its own soft shadow onto the face via
// Canvas.drawShadow.

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import 'compass_ticks.dart';

class CompassFacePainter extends CustomPainter {
  CompassFacePainter({
    required this.rotationDegrees,
    required this.needleAlpha,
    this.tiltX = 0,
    this.tiltY = 0,
  });

  final double rotationDegrees;

  /// Eased toward 1.0 (trustworthy) or 0.35 (low confidence) by
  /// QiblaNeedle's AnimationController — a raw bool flipped straight
  /// into paint alpha caused a visible flicker whenever the underlying
  /// compass accuracy classification jittered near its threshold
  /// (2026-08-24 live-device review: "the icon is blinking, keeps on
  /// blinking"). Smoothing the transition here removes the flicker
  /// regardless of how often the accuracy reading itself changes.
  final double needleAlpha;

  /// Device tilt (-1..1 per axis) — shifts where the bezel's light
  /// highlight falls, so light appears to move across the metal.
  final double tiltX;
  final double tiltY;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    _paintBezel(canvas, center, radius);
    final faceRadius = radius * 0.82;
    _paintRecessedFace(canvas, center, faceRadius);
    paintCompassTicksAndLabels(canvas, center, faceRadius);
    _paintKaabaMarker(canvas, center, faceRadius);
    _paintNeedle(canvas, center, faceRadius);

    canvas.drawCircle(
      center,
      5,
      Paint()..color = AppColors.ink.withValues(alpha: 0.7),
    );
  }

  /// An octagonal, faceted housing rather than a plain circle — a
  /// distinct 3D object, not the same disc shape the needle and dial
  /// already use (2026-08-24 live-device review asked for a different
  /// representation than "a spinning/blinking circle"). Each facet
  /// gets its own gradient sliver so the housing reads as machined
  /// metal with real bevels, not a flat ring.
  Path _octagonPath(Offset center, double radius) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final angle = (math.pi / 4) * i - math.pi / 8;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  void _paintBezel(Canvas canvas, Offset center, double radius) {
    final outer = _octagonPath(center, radius);
    canvas.drawPath(
      _octagonPath(center + const Offset(0, 5), radius - 1),
      Paint()
        ..color = AppColors.ink.withValues(alpha: 0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    // The highlight drifts opposite the tilt, as if light were fixed
    // overhead and the bezel were tipping under it.
    final lightOffset = Offset(-tiltX, -tiltY) * radius * 0.6;
    canvas.drawPath(
      outer,
      Paint()
        ..shader = ui.Gradient.radial(
          center + lightOffset,
          radius * 1.4,
          // Dark titanium/obsidian metal with a subtle gold rim
          // reflection at the light-facing edge — was a plain white
          // highlight, which read as generic chrome rather than the
          // app's own dark-metal-with-gold-accent material.
          [AppColors.gold.withValues(alpha: 0.35), AppColors.card],
        ),
    );
    // Each facet edge gets its own thin highlight/shadow pair, so the
    // octagon reads as bevelled metal rather than a flat cut-out.
    for (var i = 0; i < 8; i++) {
      final a1 = (math.pi / 4) * i - math.pi / 8;
      final a2 = (math.pi / 4) * (i + 1) - math.pi / 8;
      final p1 = center + Offset(math.cos(a1), math.sin(a1)) * radius;
      final p2 = center + Offset(math.cos(a2), math.sin(a2)) * radius;
      final facingLight = math.cos((a1 + a2) / 2) * -tiltX + math.sin((a1 + a2) / 2) * -tiltY;
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..strokeWidth = 1.2
          ..color = (facingLight > 0 ? AppColors.gold : AppColors.ink)
              .withValues(alpha: 0.25),
      );
    }
    canvas.drawPath(
      outer,
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

  void _paintKaabaMarker(Canvas canvas, Offset center, double faceRadius) {
    // A small fixed marker at true-north-up on the dial, showing where
    // the Kaaba direction sits relative to the ring — the needle does
    // the live pointing; this is the dial's own landmark.
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
    final path = Path()
      ..moveTo(0, -length)
      ..lineTo(length * 0.13, length * 0.25)
      ..lineTo(0, length * 0.12)
      ..lineTo(-length * 0.13, length * 0.25)
      ..close();

    if (needleAlpha > 0.7) {
      canvas.save();
      canvas.translate(2.5, 3.5);
      canvas.drawShadow(path, AppColors.ink, 3, false);
      canvas.restore();
    }

    final alpha = needleAlpha;
    final rect = path.getBounds();
    canvas.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(rect.topCenter, rect.bottomCenter, [
          AppColors.accentSecondary.withValues(alpha: alpha),
          AppColors.accentSecondary.withValues(alpha: alpha * 0.7),
        ]),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CompassFacePainter oldDelegate) =>
      oldDelegate.rotationDegrees != rotationDegrees ||
      oldDelegate.needleAlpha != needleAlpha ||
      oldDelegate.tiltX != tiltX ||
      oldDelegate.tiltY != tiltY;
}
