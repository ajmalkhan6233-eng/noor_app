// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Large circular tap target for counting Tawaf circuits or Sa'i
// rounds (1-7) — same visual language as the Tasbih counter,
// including its particle-burst celebration on the 7th (final) one.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/effects/particle_burst.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

class PilgrimageCounterButton extends StatefulWidget {
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

  @override
  State<PilgrimageCounterButton> createState() => _PilgrimageCounterButtonState();
}

class _PilgrimageCounterButtonState extends State<PilgrimageCounterButton> {
  @override
  void didUpdateWidget(PilgrimageCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing && !oldWidget.pulsing) {
      ParticleBurst.play(context);
    }
  }

  bool get _isFinished => widget.count >= 7;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: semanticCountLabel(widget.semanticLabel, widget.count),
      hint: widget.semanticHint,
      enabled: widget.onTap != null,
      onTap: widget.onTap ?? () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.card,
          border: Border.all(
            color: _isFinished ? AppColors.emerald : AppColors.emeraldSoft,
            width: widget.pulsing || _isFinished ? 5 : 3,
          ),
          boxShadow: widget.pulsing
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
            Text('${widget.count}', style: AppTypography.counter),
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
