// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Section 3's daily spiritual goals list. Concrete interpretation:
// today's five prayers, from the existing PrayerTrackerCubit/
// PrayerTrackerRepository (the only real per-day completable-goal data
// already in the app) — tap to mark done, same particle+haptic
// feedback pattern as the Tasbih orb (see tasbih_orb.dart), fired
// directly from the tap handler since a prayer only "completes" once
// per day rather than repeatedly like a tasbih count.
//
// Two corrections from live-device review (2026-08-24): a prayer
// whose adhan hasn't happened yet today can't be marked done (it
// hasn't occurred) — gated here using [todayTimes] rather than just
// trusting any tap; and day navigation (max 2 days back, never into
// the future) lets someone catch up on a missed day without that
// restriction applying to days that have already fully passed.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/effects/particle_burst.dart';
import '../../../../core/haptics/haptic_service.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_times/data/prayer_times_result.dart';
import '../../../prayer_tracker/data/prayer_tracker_repository.dart';
import '../../../prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import '../../../prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_state.dart';
import '../../../../core/constants/app_color_tokens.dart';

class DailyGoalsList extends StatelessWidget {
  const DailyGoalsList({
    super.key,
    this.todayTimes,
    this.hapticService = const HapticService(),
  });

  /// Today's computed prayer times, used only to gate today's own
  /// rows — a prayer whose adhan hasn't happened yet can't be marked
  /// done. `null` (location not resolved yet) blocks every row for
  /// today rather than ungating all of them — the old "leave it open"
  /// behavior let someone with no location set tick off all five
  /// prayers at once regardless of actual time, defeating the point
  /// of the gate (found live, 2026-08-26).
  final PrayerTimesComputed? todayTimes;
  final HapticService hapticService;

  bool _hasOccurred(String prayer) {
    final times = todayTimes;
    if (times == null) return false;
    final now = DateTime.now();
    for (final (name, time) in times.prayerEntries) {
      if (name == prayer) return !time.isAfter(now);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
      builder: (context, state) {
        final cubit = context.read<PrayerTrackerCubit>();
        final isToday = state.isViewingToday;
        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: SectionHeader(l10n.dailyGoalsSectionTitle)),
                  SemanticButton(
                    label: 'Previous day',
                    onTap: cubit.goToPreviousDay,
                    child: Icon(Icons.chevron_left, color: context.colors.gold, size: 20),
                  ),
                  Text(
                    isToday ? 'Today' : DateFormat.MMMd().format(state.viewedDate),
                    style: TextStyle(color: context.colors.sage, fontSize: 12),
                  ),
                  SemanticButton(
                    label: 'Next day',
                    onTap: cubit.goToNextDay,
                    child: Icon(
                      Icons.chevron_right,
                      color: isToday ? context.colors.hairline : context.colors.gold,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final prayer in trackedPrayers)
                _GoalRow(
                  label: prayer,
                  done: state.completedPrayers.contains(prayer),
                  enabled: !isToday || _hasOccurred(prayer),
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
  const _GoalRow({
    required this.label,
    required this.done,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool done;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = !enabled
        ? context.colors.hairline
        : done
        ? context.colors.gold
        : context.colors.sage;
    return SemanticButton(
      label: label,
      hint: !enabled
          ? 'Not yet due today'
          : done
          ? l10n.unmarkPrayerHint(label)
          : l10n.markPrayerDoneHint(label),
      enabled: enabled,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(color: done ? context.colors.gold : (enabled ? context.colors.ink : context.colors.sage), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
