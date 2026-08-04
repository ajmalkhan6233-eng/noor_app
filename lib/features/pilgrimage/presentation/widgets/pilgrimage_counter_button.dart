// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Large circular tap target for counting Tawaf circuits or Sa'i
// rounds (1-7) — same visual language as the Tasbih counter, with a
// distinct highlight once the 7th is reached.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PilgrimageCounterButton extends StatelessWidget {
  const PilgrimageCounterButton({
    super.key,
    required this.count,
    required this.semanticLabel,
    required this.semanticHint,
    required this.onTap,
    this.pulsing = false,
  });

  final int count;
  final String semanticLabel;
  final String semanticHint;
  final VoidCallback? onTap;

  /// True for one frame right after the 7th circuit/round completes.
  final bool pulsing;

  bool get _isFinished => count >= 7;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: semanticCountLabel(semanticLabel, count),
      hint: semanticHint,
      enabled: onTap != null,
      onTap: onTap ?? () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.card,
          border: Border.all(
            color: _isFinished ? AppColors.emerald : AppColors.emeraldSoft,
            width: pulsing || _isFinished ? 5 : 3,
          ),
          boxShadow: pulsing
              ? [
                  BoxShadow(
                    color: AppColors.emerald.withValues(alpha: 0.5),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ]
              : const [],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$count', style: AppTypography.counter),
            Text(
              AppLocalizations.of(context)!.ofSevenSuffix,
              style: const TextStyle(color: AppColors.sage, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
