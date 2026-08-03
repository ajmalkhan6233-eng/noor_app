// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
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
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                item.arabicText,
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 20),
              ),
              if (item.transliteration != null) ...[
                const SizedBox(height: 8),
                Text(
                  item.transliteration!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              if (item.translation != null) ...[
                const SizedBox(height: 4),
                Text(
                  item.translation!,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                'Source: ${item.source}',
                style: const TextStyle(color: AppColors.divider, fontSize: 11),
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
                      color: done ? AppColors.milestone : AppColors.accent,
                    ),
                  ),
                  child: Text(
                    '$count / ${item.repeatCount}',
                    style: TextStyle(
                      color: done ? AppColors.milestone : AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
