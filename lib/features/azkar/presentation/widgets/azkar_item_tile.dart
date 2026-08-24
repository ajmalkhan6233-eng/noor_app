// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/effects/particle_burst.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/azkar_item.dart';
import '../../logic/azkar_cubit/azkar_cubit.dart';
import '../../logic/azkar_cubit/azkar_state.dart';

/// One dhikr with a tap-to-count repetition counter.
class AzkarItemTile extends StatelessWidget {
  const AzkarItemTile({super.key, required this.item});

  final AzkarItem item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AzkarCubit, AzkarState>(
      builder: (context, state) {
        final count = state.progressFor(item.id);
        final done = count >= item.repeatCount;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic is the primary element here, not the
                // transliteration/translation underneath it — sized up
                // and given more line height so it reads first
                // (2026-08-24 live-device review: Arabic was too small
                // relative to an over-long English block).
                Text(
                  item.arabicText,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: AppTypography.arabic.copyWith(fontSize: 26, height: 1.7),
                ),
                if (item.transliteration != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    item.transliteration!,
                    style: const TextStyle(
                      color: AppColors.sage,
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (item.translation != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.translation!,
                    style: const TextStyle(color: AppColors.sage, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Source: ${item.source}',
                  style: const TextStyle(color: AppColors.sage, fontSize: 11),
                ),
                const SizedBox(height: 12),
                _CounterButton(
                  count: count,
                  repeatCount: item.repeatCount,
                  done: done,
                  onTap: () => context.read<AzkarCubit>().increment(item.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Split out from [AzkarItemTile] so a plain constructor prop (rather
/// than an internal BlocBuilder rebuild) drives [didUpdateWidget] —
/// that's what lets us detect the false-to-true edge of [done] safely,
/// the same pattern HapticCounterButton and QiblaCompassArea already
/// use for their own particle bursts.
class _CounterButton extends StatefulWidget {
  const _CounterButton({
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
  State<_CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<_CounterButton> {
  @override
  void didUpdateWidget(_CounterButton oldWidget) {
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
            color: widget.done ? AppColors.gold : AppColors.hairline,
          ),
        ),
        child: Text(
          widget.done
              ? 'Done · ${widget.count} of ${widget.repeatCount}'
              : 'Tap to count · ${widget.count} of ${widget.repeatCount}',
          style: TextStyle(
            color: widget.done ? AppColors.gold : AppColors.ink,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
