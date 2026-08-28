// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A simple offline log: mark each of today's five prayers done, and
// today's fast if observed, with a running streak shown for each.
// Everything here is local-only — no account, no sync.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_times/data/prayer_times_result.dart';
import '../../data/prayer_tracker_repository.dart';
import '../../logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import '../../logic/prayer_tracker_cubit/prayer_tracker_state.dart';
import '../progress_screen.dart';
import '../../../../core/constants/app_color_tokens.dart';

// Reads the PrayerTrackerCubit provided by HomeDashboard (shared with
// Home's DailyGoalsList) rather than creating its own — so marking a
// prayer done here shows up on the Home tab immediately instead of
// each tab holding its own stale copy. [todayTimes] gates today's
// rows to prayers whose adhan has actually happened, same as
// DailyGoalsList — was missing here (2026-08-24 live-device review:
// "in the second page, today's prayer can select... should not be
// able to select because it's not yet finished").
class PrayerTrackerCard extends StatelessWidget {
  const PrayerTrackerCard({super.key, this.todayTimes});

  final PrayerTimesComputed? todayTimes;

  bool _hasOccurred(String prayer) {
    final times = todayTimes;
    if (times == null) return true;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: SectionHeader(l10n.todaysPrayersLabel)),
                  SemanticButton(
                    label: 'Previous day',
                    onTap: cubit.goToPreviousDay,
                    child: Icon(Icons.chevron_left, color: context.colors.gold, size: 20),
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final prayer in trackedPrayers)
                    _PrayerChip(
                      label: prayer,
                      done: state.completedPrayers.contains(prayer),
                      enabled: !isToday || _hasOccurred(prayer),
                      onTap: () => cubit.togglePrayer(prayer),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                state.prayerStreak == 0
                    ? l10n.noPrayerStreakMessage
                    : l10n.prayerStreakLabel(state.prayerStreak),
                style: AppTypography.caption(context.colors.sage),
              ),
              const SizedBox(height: 16),
              Divider(color: context.colors.hairline, height: 1),
              const SizedBox(height: 16),
              SemanticButton(
                label: l10n.fastingTodayLabel,
                hint: state.fastingToday ? l10n.unmarkFastingHint : l10n.markFastingHint,
                onTap: cubit.toggleFasting,
                child: Row(
                  children: [
                    Icon(
                      state.fastingToday
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: state.fastingToday
                          ? context.colors.gold
                          : context.colors.sage,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.fastingTodayLabel, style: TextStyle(color: context.colors.ink)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                state.fastingStreak == 0
                    ? l10n.noFastingStreakMessage
                    : l10n.fastingStreakLabel(state.fastingStreak),
                style: AppTypography.caption(context.colors.sage),
              ),
              const SizedBox(height: 12),
              SemanticButton(
                label: 'View your progress',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const ProgressScreen()),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, color: context.colors.gold, size: 16),
                    const SizedBox(width: 6),
                    Text('View your progress', style: TextStyle(color: context.colors.gold)),
                  ],
                ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: done ? context.colors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: enabled ? (done ? context.colors.gold : context.colors.hairline) : context.colors.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              done ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
