// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../data/azkar_item.dart';
import '../../logic/azkar_cubit/azkar_cubit.dart';
import '../../logic/azkar_cubit/azkar_state.dart';
import 'azkar_counter_button.dart';

/// One dhikr with a tap-to-count repetition counter. Text size follows
/// [fontScale] from Settings — previously hardcoded, so the Quran
/// text-size slider had no effect here even though this is the same
/// kind of Arabic devotional text (2026-08-25 audit).
class AzkarItemTile extends StatelessWidget {
  const AzkarItemTile({super.key, required this.item, this.fontScale = 1.0});

  final AzkarItem item;
  final double fontScale;

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
                  style: AppTypography.arabic.copyWith(
                    fontSize: 26 * fontScale,
                    height: 1.7,
                  ),
                ),
                if (item.transliteration != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    item.transliteration!,
                    style: TextStyle(
                      color: AppColors.sage,
                      fontStyle: FontStyle.italic,
                      fontSize: 13 * fontScale,
                    ),
                  ),
                ],
                if (item.translation != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.translation!,
                    style: TextStyle(color: AppColors.sage, fontSize: 12 * fontScale),
                  ),
                ],
                const SizedBox(height: 12),
                AzkarCounterButton(
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
