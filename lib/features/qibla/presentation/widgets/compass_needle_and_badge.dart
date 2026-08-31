// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The compass dial's rotating layer (needle + Kaaba badge), split out
// of qibla_compass_dial.dart. Root-caused 2026-08-30: the raw compass
// sensor stream has no throttling (qibla_sensor_binder.dart emits on
// every reading, uncapped), and this dial's earlier version consumed
// that rotation directly in a stateless build() — meaning the entire
// heavy multi-layer Stack (rings, ticks, Arabic label, needle, badge)
// repainted on every single raw sensor event, likely far faster than
// the display's own refresh rate. The old (pre-rebuild) QiblaNeedle
// widget never had this problem because it kept its own local
// Ticker-smoothed `_displayedRotation`, decoupling paint frequency
// from sensor frequency — that decoupling got lost in the rebuild and
// is restored here, now scoped to just this rotating layer via its
// own RepaintBoundary so the static rings/label beneath never need to
// repaint alongside it either.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/utils/angle_math.dart';
import 'compass_needle_painter.dart';
import 'kaaba_badge_painter.dart';

class CompassNeedleAndBadge extends StatefulWidget {
  const CompassNeedleAndBadge({
    super.key,
    required this.diameter,
    required this.targetRotationDegrees,
    required this.alpha,
    required this.locked,
    required this.cyan,
    required this.gold,
  });

  final double diameter;
  final double targetRotationDegrees;
  final double alpha;
  final bool locked;
  final Color cyan;
  final Color gold;

  @override
  State<CompassNeedleAndBadge> createState() => _CompassNeedleAndBadgeState();
}

class _CompassNeedleAndBadgeState extends State<CompassNeedleAndBadge> with SingleTickerProviderStateMixin {
  static const _smoothingFactor = 0.18;

  late final Ticker _ticker;
  late double _displayedRotation = widget.targetRotationDegrees;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration _) {
    final next = AngleMath.smooth(_displayedRotation, widget.targetRotationDegrees, _smoothingFactor);
    if (next == _displayedRotation) return;
    setState(() => _displayedRotation = next);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final angle = _displayedRotation * 3.14159265 / 180;
    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: angle,
            child: SizedBox(
              width: widget.diameter,
              height: widget.diameter,
              child: CustomPaint(
                painter: CompassNeedlePainter(alpha: widget.alpha, locked: widget.locked, cyan: widget.cyan, gold: widget.gold),
              ),
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
                child: CustomPaint(painter: KaabaBadgePainter(alpha: widget.alpha, gold: widget.gold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
