// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of TasbihOrb to keep that file under the project's
// line-count convention. The sphere's visual surface only — a layered
// gold-metallic radial gradient with a cyan rim glow (dominant/sparing
// per the locked palette), plus two off-centre highlight ellipses —
// a bright one catching the near edge, a cooler cyan-tinted one on
// the far edge — for a genuine metallic sheen instead of a flat fill.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';

class OrbFace extends StatelessWidget {
  const OrbFace({
    super.key,
    required this.count,
    required this.pulsing,
    this.pullFraction = 0.0,
  });

  final int count;
  final bool pulsing;

  /// 0.0 (resting) to 1.0 (at max drag distance) — ties the rim glow's
  /// intensity to how far the orb is currently being pulled, so the
  /// glow itself reads as a response to touch rather than a static
  /// decoration (2026-08-29 polish pass).
  final double pullFraction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 1.15,
          colors: [
            context.colors.card,
            context.colors.gold.withValues(alpha: 0.45),
            context.colors.gold.withValues(alpha: 0.95),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        border: Border.all(
          color: context.colors.gold,
          width: pulsing ? 5 : 3,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.paper.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          // Cyan rim glow on the far edge — the palette's "sparing,
          // specific spots only" secondary accent. Brightens and
          // widens with pullFraction so the glow visibly answers the
          // drag itself, not just a fixed decoration.
          BoxShadow(
            color: context.colors.accentSecondary
                .withValues(alpha: 0.3 + pullFraction * 0.35),
            blurRadius: 18 + pullFraction * 14,
            spreadRadius: -4 + pullFraction * 6,
            offset: const Offset(8, 8),
          ),
          if (pulsing)
            BoxShadow(
              color: context.colors.gold.withValues(alpha: 0.5),
              blurRadius: 24,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bright specular highlight catching the near (upper-left) edge.
          Positioned(
            left: 44,
            top: 36,
            child: Container(
              width: 54,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withValues(alpha: 0.6), Colors.white.withValues(alpha: 0)],
                ),
              ),
            ),
          ),
          // Cooler cyan-tinted glint on the far (lower-right) edge, for
          // a genuine two-tone metallic sheen rather than a flat fill.
          Positioned(
            right: 40,
            bottom: 46,
            child: Container(
              width: 34,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.colors.accentSecondary.withValues(alpha: 0.4),
                    context.colors.accentSecondary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Text('$count', style: AppTypography.counter(context.colors.ink)),
        ],
      ),
    );
  }
}
