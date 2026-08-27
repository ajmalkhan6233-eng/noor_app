// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The needle's outer circle/border — split out of qibla_needle.dart to
// stay under the 150-line-per-file rule. Swaps to a gold border + glow
// when [locked] (facing the qibla within the lock threshold).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class QiblaNeedleRing extends StatelessWidget {
  const QiblaNeedleRing({super.key, required this.locked});

  final bool locked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.card,
        border: Border.fromBorderSide(
          BorderSide(
            color: locked ? AppColors.gold : AppColors.hairline,
            width: 1.5,
          ),
        ),
        boxShadow: locked
            ? [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.45),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ]
            : const [],
      ),
    );
  }
}
