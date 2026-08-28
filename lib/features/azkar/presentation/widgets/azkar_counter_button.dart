// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of azkar_item_tile.dart (2026-08-26, to stay under the
// 150-line-per-file rule after adding the source-citation line) so a
// plain constructor prop (rather than an internal BlocBuilder
// rebuild) drives didUpdateWidget — that's what lets us detect the
// false-to-true edge of [done] safely, the same pattern
// HapticCounterButton and QiblaCompassArea already use for their own
// particle bursts.

import 'package:flutter/material.dart';

import '../../../../core/effects/particle_burst.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../core/constants/app_color_tokens.dart';

class AzkarCounterButton extends StatefulWidget {
  const AzkarCounterButton({
    super.key,
    required this.count,
    required this.repeatCount,
    required this.done,
    required this.onTap,
  });

  final int count;
  final int repeatCount;
  final bool done;
  final VoidCallback onTap;

  @override
  State<AzkarCounterButton> createState() => _AzkarCounterButtonState();
}

class _AzkarCounterButtonState extends State<AzkarCounterButton> {
  @override
  void didUpdateWidget(AzkarCounterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.done && !oldWidget.done) {
      ParticleBurst.play(context, intensity: 0.35);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: 'Count for this dhikr: ${widget.count} of ${widget.repeatCount}',
      hint: 'Double tap to count one repetition',
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.done ? context.colors.gold : context.colors.hairline,
          ),
        ),
        child: Text(
          widget.done
              ? 'Done · ${widget.count} of ${widget.repeatCount}'
              : 'Tap to count · ${widget.count} of ${widget.repeatCount}',
          style: TextStyle(
            color: widget.done ? context.colors.gold : context.colors.ink,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
