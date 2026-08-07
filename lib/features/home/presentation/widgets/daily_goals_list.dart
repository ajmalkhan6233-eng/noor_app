// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 3's daily spiritual goals list. Concrete interpretation:
// today's five prayers, from the existing PrayerTrackerCubit/
// PrayerTrackerRepository (the only real per-day completable-goal data
// already in the app) — tap to mark done, same particle+haptic
// feedback pattern as the Tasbih orb (see tasbih_orb.dart), fired
// directly from the tap handler since a prayer only "completes" once
// per day rather than repeatedly like a tasbih count.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/effects/particle_burst.dart';
import '../../../../core/haptics/haptic_service.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_tracker/data/prayer_tracker_repository.dart';
import '../../../prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import '../../../prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_state.dart';

class DailyGoalsList extends StatelessWidget {
  const DailyGoalsList({super.key, this.hapticService = const HapticService()});

  final HapticService hapticService;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
      builder: (context, state) {
        final cubit = context.read<PrayerTrackerCubit>();
        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(l10n.dailyGoalsSectionTitle),
              const SizedBox(height: 8),
              for (final prayer in trackedPrayers)
                _GoalRow(
                  label: prayer,
                  done: state.completedPrayers.contains(prayer),
                  onTap: () {
                    final wasDone = state.completedPrayers.contains(prayer);
                    hapticService.tap();
                    if (!wasDone) ParticleBurst.play(context, intensity: 0.35);
                    cubit.togglePrayer(prayer);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({required this.label, required this.done, required this.onTap});

  final String label;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SemanticButton(
      label: label,
      hint: done ? l10n.unmarkPrayerHint(label) : l10n.markPrayerDoneHint(label),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: done ? AppColors.gold : AppColors.sage,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: done ? AppColors.gold : AppColors.ink, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
