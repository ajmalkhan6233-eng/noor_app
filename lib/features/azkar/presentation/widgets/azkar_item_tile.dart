// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
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
                Text(
                  item.arabicText,
                  textDirection: TextDirection.rtl,
                  style: AppTypography.arabic.copyWith(fontSize: 20),
                ),
                if (item.transliteration != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.transliteration!,
                    style: const TextStyle(
                      color: AppColors.sage,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (item.translation != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.translation!,
                    style: const TextStyle(color: AppColors.sage),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Source: ${item.source}',
                  style: const TextStyle(color: AppColors.sage, fontSize: 11),
                ),
                const SizedBox(height: 12),
                SemanticButton(
                  label: 'Count for this dhikr: $count of ${item.repeatCount}',
                  hint: 'Double tap to count one repetition',
                  onTap: () => context.read<AzkarCubit>().increment(item.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: done ? AppColors.gold : AppColors.hairline,
                      ),
                    ),
                    child: Text(
                      '$count / ${item.repeatCount}',
                      style: TextStyle(
                        color: done ? AppColors.gold : AppColors.parchment,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
