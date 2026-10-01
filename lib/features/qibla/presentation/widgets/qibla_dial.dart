// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The compass: a ring that turns opposite to the phone (so N always
// points to true north) and a needle that points at the Qibla. Plain
// Transform.rotate on ordinary widgets — no custom painting — so it
// renders the same with Impeller on or off. Angles are fed already
// smoothed and wrap-safe: a full-turn jump (359 -> 1 degrees) looks
// like a 2-degree move because rotation is periodic.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/corner_radius.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';

class QiblaDial extends StatelessWidget {
  const QiblaDial({
    super.key,
    required this.heading,
    required this.needleAngle,
    required this.aligned,
    this.size = 280,
  });

  /// Device heading in degrees, or null to draw the ring north-up.
  final double? heading;

  /// Needle angle in degrees from the top of the phone.
  final double needleAngle;
  final bool aligned;
  final double size;

  static double radians(double degrees) => degrees * math.pi / 180;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.qiblaNeedleSemantics(needleAngle.round()),
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: -radians(heading ?? 0),
              child: _Ring(size: size),
            ),
            Transform.rotate(
              angle: radians(needleAngle),
              child: _Needle(
                length: size,
                color: aligned ? colors.accentSecondary : colors.gold,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Icon(Icons.arrow_drop_down, color: colors.sage, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget letter(String text, Alignment alignment) => Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(text, style: AppTypography.sectionHeader(colors.sage)),
      ),
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.card,
        border: Border.all(color: colors.hairline, width: 2),
      ),
      child: Stack(
        children: [
          letter('N', Alignment.topCenter),
          letter('E', Alignment.centerRight),
          letter('S', Alignment.bottomCenter),
          letter('W', Alignment.centerLeft),
        ],
      ),
    );
  }
}

class _Needle extends StatelessWidget {
  const _Needle({required this.length, required this.color});

  final double length;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final half = length / 2 - 40;
    return SizedBox(
      width: 48,
      height: length - 80,
      child: Column(
        children: [
          Icon(Icons.navigation, size: 52, color: color),
          Expanded(
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(context.radiusFor(2)),
              ),
            ),
          ),
          SizedBox(height: half),
        ],
      ),
    );
  }
}
