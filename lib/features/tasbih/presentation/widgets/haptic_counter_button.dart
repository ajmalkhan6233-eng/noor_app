// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure presentation: displays the count and forwards taps upward. It
// never touches the Cubit's internals or the database directly.

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/semantics_helpers.dart';

/// Large, accessible circular counter button used by the tasbih screen.
class HapticCounterButton extends StatelessWidget {
  const HapticCounterButton({
    super.key,
    required this.count,
    required this.onTap,
    this.pulsing = false,
  });

  final int count;
  final VoidCallback onTap;

  /// True for one frame after a milestone is hit — used to trigger a
  /// brief visual glow in sync with the heavier haptic pulse.
  final bool pulsing;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: semanticCountLabel(
        AppStrings.tasbihCounterSemanticLabel,
        count,
      ),
      hint: 'Double tap to increment',
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.card,
          border: Border.all(
            color: pulsing ? AppColors.gold : AppColors.gold,
            width: pulsing ? 5 : 3,
          ),
          boxShadow: pulsing
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.5),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ]
              : const [],
        ),
        alignment: Alignment.center,
        child: Text('$count', style: AppTypography.counter),
      ),
    );
  }
}
