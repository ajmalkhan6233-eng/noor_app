// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A simple offline log: mark each of today's five prayers done, and
// today's fast if observed, with a running streak shown for each.
// Everything here is local-only — no account, no sync.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/prayer_tracker_repository.dart';
import '../../logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import '../../logic/prayer_tracker_cubit/prayer_tracker_state.dart';

class PrayerTrackerCard extends StatelessWidget {
  const PrayerTrackerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrayerTrackerCubit()..load(),
      child: const _PrayerTrackerCardView(),
    );
  }
}

class _PrayerTrackerCardView extends StatelessWidget {
  const _PrayerTrackerCardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
      builder: (context, state) {
        final cubit = context.read<PrayerTrackerCubit>();
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader("Today's prayers"),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final prayer in trackedPrayers)
                    _PrayerChip(
                      label: prayer,
                      done: state.completedPrayers.contains(prayer),
                      onTap: () => cubit.togglePrayer(prayer),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                state.prayerStreak == 0
                    ? 'No current prayer streak'
                    : 'Prayer streak: ${state.prayerStreak} day${state.prayerStreak == 1 ? '' : 's'}',
                style: AppTypography.caption,
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.hairline, height: 1),
              const SizedBox(height: 16),
              SemanticButton(
                label: 'Fasting today',
                hint: state.fastingToday
                    ? 'Double tap to unmark today as fasted'
                    : 'Double tap to mark today as fasted',
                onTap: cubit.toggleFasting,
                child: Row(
                  children: [
                    Icon(
                      state.fastingToday
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: state.fastingToday
                          ? AppColors.emerald
                          : AppColors.sage,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text('Fasting today', style: TextStyle(color: AppColors.ink)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                state.fastingStreak == 0
                    ? 'No current fasting streak'
                    : 'Fasting streak: ${state.fastingStreak} day${state.fastingStreak == 1 ? '' : 's'}',
                style: AppTypography.caption,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PrayerChip extends StatelessWidget {
  const _PrayerChip({
    required this.label,
    required this.done,
    required this.onTap,
  });

  final String label;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: label,
      hint: done ? 'Double tap to unmark $label' : 'Double tap to mark $label done',
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: done ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: done ? AppColors.emerald : AppColors.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16,
              color: done ? AppColors.emerald : AppColors.sage,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: done ? AppColors.emerald : AppColors.sage, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
