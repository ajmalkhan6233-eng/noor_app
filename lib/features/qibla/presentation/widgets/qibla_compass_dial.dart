// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The redesigned Qibla compass dial (2026-08-30 mockup rebuild):
// ring stack + ticks (compass_rings_painter.dart, static), the
// tapered needle (compass_needle_painter.dart) and Kaaba badge
// (kaaba_badge_painter.dart) both rotated to the live bearing, the
// Arabic "القبلة" label, and a small heading readout tucked to the
// side. ~336dp per the approved design.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import 'compass_needle_painter.dart';
import 'compass_rings_painter.dart';
import 'kaaba_badge_painter.dart';
import 'qibla_arabic_label.dart';
import 'qibla_heading_readout.dart';

class QiblaCompassDial extends StatelessWidget {
  const QiblaCompassDial({
    super.key,
    required this.rotationDegrees,
    required this.dimmed,
    required this.headingDegrees,
    required this.bearingDegrees,
  });

  static const double diameter = 336;

  /// Needle/Kaaba-badge rotation — bearing relative to current facing,
  /// same meaning as the previous QiblaNeedle widget.
  final double rotationDegrees;
  final bool dimmed;
  final double? headingDegrees;
  final double bearingDegrees;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final alpha = dimmed ? 0.35 : 1.0;
    final angle = rotationDegrees * 3.14159265 / 180;

    return SizedBox(
      width: diameter + 40,
      height: diameter + 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: diameter + 52,
            height: diameter + 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [colors.gold.withValues(alpha: 0.30), colors.gold.withValues(alpha: 0.08), colors.gold.withValues(alpha: 0)],
                stops: const [0, 0.55, 0.76],
              ),
            ),
          ),
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
          Positioned(
            right: diameter * 0.09,
            bottom: diameter * 0.22,
            child: QiblaHeadingReadout(headingDegrees: headingDegrees, bearingDegrees: bearingDegrees),
          ),
          Transform.rotate(
            angle: angle,
            child: SizedBox(
              width: diameter,
              height: diameter,
              child: CustomPaint(painter: CompassNeedlePainter(alpha: alpha, cyan: colors.accentSecondary, gold: colors.gold)),
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
