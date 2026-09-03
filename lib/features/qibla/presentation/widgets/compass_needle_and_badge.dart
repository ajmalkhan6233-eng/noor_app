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
//
// 2026-09-03: the needle switched from a CustomPainter (Canvas/Path
// draw calls issued fresh every frame) to a pre-rendered static PNG
// (scripts/gen_qibla_needle.js) rotated via plain Transform.rotate —
// every version of the CustomPainter needle (original, jeweled-star,
// simplified) reproduced the same blank/collapse rendering glitch on
// the test device, tracking with draw-call count rather than any one
// shape's complexity. A static image rotated by the compositor is a
// GPU texture-rotate, not a redraw, which is the actual thing being
// tested here — see CLAUDE.md's log for the live pixel-diffed burst
// result. The Kaaba badge still uses its own CustomPainter (untouched,
// out of scope for this pass) since the request targeted the needle.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/utils/angle_math.dart';
import 'kaaba_badge_painter.dart';

class CompassNeedleAndBadge extends StatefulWidget {
  const CompassNeedleAndBadge({
    super.key,
    required this.diameter,
    required this.targetRotationDegrees,
    required this.alpha,
    required this.locked,
    required this.gold,
  });

  final double diameter;
  final double targetRotationDegrees;
  final double alpha;
  final bool locked;
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
            child: Opacity(
              opacity: widget.alpha,
              child: Image.asset(
                widget.locked ? 'assets/qibla/needle_gold.png' : 'assets/qibla/needle_cyan.png',
                width: widget.diameter,
                height: widget.diameter,
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
