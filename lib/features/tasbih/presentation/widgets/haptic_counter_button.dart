// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure presentation: displays the count and forwards taps upward. It
// never touches the Cubit's internals or the database directly. The
// milestone particle burst reacts to the same `pulsing` flag the
// glow already uses — no separate milestone detection here, that
// stays owned by TasbihState/HapticService.

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/effects/particle_burst.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Large, accessible circular counter button used by the tasbih screen.
class HapticCounterButton extends StatefulWidget {
  const HapticCounterButton({
    super.key,
    required this.count,
    required this.onTap,
    this.pulsing = false,
  });

  final int count;
  final VoidCallback onTap;

  /// True for one frame after a milestone is hit — used to trigger a
  /// brief visual glow (and a matching particle burst) in sync with
  /// the heavier haptic pulse.
  final bool pulsing;

  @override
  State<HapticCounterButton> createState() => _HapticCounterButtonState();
}

class _HapticCounterButtonState extends State<HapticCounterButton> {
  @override
  void didUpdateWidget(HapticCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing && !oldWidget.pulsing) {
      ParticleBurst.play(context, intensity: 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SemanticButton(
      label: semanticCountLabel(l10n.tasbihCounterSemanticLabel, widget.count),
      hint: l10n.tasbihIncrementHint,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.card,
          border: Border.all(
            color: AppColors.emerald,
            width: widget.pulsing ? 5 : 3,
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
        child: Text('${widget.count}', style: AppTypography.counter),
      ),
    );
  }
}
