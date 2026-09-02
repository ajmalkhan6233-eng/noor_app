// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Qibla compass dial: needle-only, no ring/tick decoration behind
// it (2026-09-02 direct request — the ring stack from the 2026-08-30
// mockup rebuild, compass_rings_painter.dart, is removed here and no
// longer used anywhere). Just the rotating needle + Kaaba badge
// (compass_needle_and_badge.dart — a separate widget specifically so
// its own Ticker can decouple its repaint rate from the raw compass
// sensor stream, see that file's header for why that turned out to be
// the dial's real rendering-glitch root cause) and the Arabic
// "القبلة" label. ~336dp per the approved design.
//
// Solid-color needle/badge (no gradients, no blur) per direct request
// ("no need 3D, just a plain compass") — kept even after finding the
// real root cause above, since flat colors are still the simplest,
// most conservative choice while any residual rendering risk on this
// device class remains unconfirmed long-term.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import 'compass_needle_and_badge.dart';
import 'qibla_arabic_label.dart';

class QiblaCompassDial extends StatelessWidget {
  const QiblaCompassDial({
    super.key,
    required this.rotationDegrees,
    required this.dimmed,
    required this.locked,
  });

  static const double diameter = 336;

  /// Target rotation for the needle/badge to ease toward — bearing
  /// relative to current facing, same meaning as the previous
  /// QiblaNeedle widget. The badge can land anywhere on the ring
  /// depending on this value, which is why the FACING/QIBLA readout is
  /// NOT drawn inside this dial — it used to be, at a fixed corner,
  /// and collided with the badge/needle the moment a real bearing
  /// happened to rotate through that corner (found live, 2026-08-30).
  /// It's a sibling row below the dial now, in qibla_compass_area.dart.
  final double rotationDegrees;
  final bool dimmed;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final alpha = dimmed ? 0.35 : 1.0;

    return Container(
      width: diameter + 40,
      height: diameter + 40,
      color: colors.paper,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: diameter * 0.28,
            child: QiblaArabicLabel(color: colors.gold.withValues(alpha: 0.8)),
          ),
          CompassNeedleAndBadge(
            diameter: diameter,
            targetRotationDegrees: rotationDegrees,
            alpha: alpha,
            locked: locked,
            cyan: colors.accentSecondary,
            gold: colors.gold,
          ),
        ],
      ),
    );
  }
}
