// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The redesigned Qibla compass dial (2026-08-30 mockup rebuild):
// ring stack + ticks (compass_rings_painter.dart, static), the
// tapered needle (compass_needle_painter.dart) and Kaaba badge
// (kaaba_badge_painter.dart) both rotated to the live bearing, and the
// Arabic "القبلة" label. ~336dp per the approved design.
//
// Opaque backing + solid-color needle/badge (no gradients, no blur):
// live-device testing right after this dial first shipped reproduced
// the exact same still-open intermittent rendering glitch already
// logged against the old QiblaNeedle widget (2026-08-29/30 entries in
// CLAUDE.md) — worse here, since it kept happening even behind an
// opaque backing (the fix that resolved the earlier, simpler case).
// Simplified 2026-08-30 per direct request ("no need 3D, just a plain
// compass") after stripping every gradient/blur/glow effect out of the
// needle, badge, and this dial's outer halo — the flattest, most
// conservative version, prioritizing something that reliably renders
// over matching the mockup's glow effects exactly. Root cause is still
// a device/driver compositing issue outside this app's control.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import 'compass_needle_painter.dart';
import 'compass_rings_painter.dart';
import 'kaaba_badge_painter.dart';
import 'qibla_arabic_label.dart';

class QiblaCompassDial extends StatelessWidget {
  const QiblaCompassDial({
    super.key,
    required this.rotationDegrees,
    required this.dimmed,
    required this.locked,
  });

  static const double diameter = 336;

  /// Needle/Kaaba-badge rotation — bearing relative to current facing,
  /// same meaning as the previous QiblaNeedle widget. The badge can
  /// land anywhere on the ring depending on this value, which is why
  /// the FACING/QIBLA readout is NOT drawn inside this dial (it used
  /// to be, at a fixed corner, and collided with the badge/needle the
  /// moment a real bearing happened to rotate through that corner —
  /// found live, 2026-08-30). It's a sibling row below the dial now,
  /// in qibla_compass_area.dart, which is never occluded regardless of
  /// rotation.
  final double rotationDegrees;
  final bool dimmed;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final alpha = dimmed ? 0.35 : 1.0;
    final angle = rotationDegrees * 3.14159265 / 180;

    return Container(
      width: diameter + 40,
      height: diameter + 40,
      color: colors.paper,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: diameter,
            height: diameter,
            child: CustomPaint(
              painter: CompassRingsPainter(gold: colors.gold, cyan: colors.accentSecondary, ink: colors.ink, sage: colors.sage),
            ),
          ),
          Positioned(
            top: diameter * 0.28,
            child: QiblaArabicLabel(color: colors.gold.withValues(alpha: 0.8)),
          ),
          Transform.rotate(
            angle: angle,
            child: SizedBox(
              width: diameter,
              height: diameter,
              child: CustomPaint(painter: CompassNeedlePainter(alpha: alpha, locked: locked, cyan: colors.accentSecondary, gold: colors.gold)),
            ),
          ),
          Transform.rotate(
            angle: angle,
            alignment: Alignment.center,
            child: Align(
              alignment: const Alignment(0, -0.76),
              child: SizedBox(
                width: 50,
                height: 50,
                child: CustomPaint(painter: KaabaBadgePainter(alpha: alpha, gold: colors.gold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
