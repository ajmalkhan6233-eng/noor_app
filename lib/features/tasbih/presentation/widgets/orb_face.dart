// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of TasbihOrb to keep that file under the project's
// line-count convention. The sphere's visual surface only — a layered
// radial gradient for a metallic/glass sheen, plus a soft off-centre
// highlight ellipse for a crystalline specular reflection.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class OrbFace extends StatelessWidget {
  const OrbFace({super.key, required this.count, required this.pulsing});

  final int count;
  final bool pulsing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 1.1,
          colors: [
            AppColors.card,
            AppColors.emeraldSoft.withValues(alpha: 0.5),
            AppColors.emerald.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        border: Border.all(
          color: AppColors.emerald,
          width: pulsing ? 5 : 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          if (pulsing)
            BoxShadow(
              color: AppColors.emerald.withValues(alpha: 0.5),
              blurRadius: 24,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 44,
            top: 36,
            child: Container(
              width: 54,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withValues(alpha: 0.55), Colors.white.withValues(alpha: 0)],
                ),
              ),
            ),
          ),
          Text('$count', style: AppTypography.counter),
        ],
      ),
    );
  }
}
