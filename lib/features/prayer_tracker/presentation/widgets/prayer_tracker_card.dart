// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A simple offline log: mark each of today's five prayers done, and
// today's fast if observed, with a running streak shown for each.
// Everything here is local-only — no account, no sync.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../prayer_times/data/prayer_times_result.dart';
import '../../data/prayer_tracker_repository.dart';
import '../../logic/prayer_tracker_cubit/prayer_tracker_cubit.dart';
import '../../logic/prayer_tracker_cubit/prayer_tracker_state.dart';
import '../../logic/prayer_tick_guard.dart';
import '../progress_screen.dart';
import '../../../../core/constants/app_color_tokens.dart';
import 'prayer_chip.dart';
import 'tracker_day_header.dart';
import '../progress/progress_ring.dart';
import '../progress/streak_flame.dart';

// Reads the PrayerTrackerCubit provided by HomeDashboard rather than
// creating its own — so marking a prayer done here shows up on the
// Home tab immediately instead of each tab holding its own stale
// copy (this card is shown on both Home and Prayer Times as of
// 2026-09-06, sharing one cubit instance). [todayTimes] gates today's
// rows to prayers whose adhan has actually happened (2026-08-24
// live-device review: "in the second page, today's prayer can
// select... should not be able to select because it's not yet
// finished").
class PrayerTrackerCard extends StatelessWidget {
  const PrayerTrackerCard({super.key, this.todayTimes});

  final PrayerTimesComputed? todayTimes;

  DateTime? _prayerStart(String prayer) {
    final times = todayTimes;
    if (times == null) return null;
    for (final (name, time) in times.prayerEntries) {
      if (name == prayer) return time;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
      builder: (context, state) {
        final cubit = context.read<PrayerTrackerCubit>();
        final isToday = state.isViewingToday;
        final now = DateTime.now();
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrackerDayHeader(title: l10n.todaysPrayersLabel, isToday: isToday, cubit: cubit),
              // The ring fills as prayers are ticked and celebrates 5/5; beside it
              // the streak with its flame.
              Row(
                children: [
                  ProgressRing(
                    done: state.completedPrayers.length,
                    size: 64,
                    semanticLabel: l10n.progressTodaySemantics(state.completedPrayers.length),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        StreakFlame(streak: state.prayerStreak),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.prayerStreak == 0
                                ? l10n.noPrayerStreakMessage
                                : l10n.prayerStreakLabel(state.prayerStreak),
                            style: AppTypography.caption(context.colors.sage),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final prayer in trackedPrayers)
                    PrayerChip(
                      label: prayer,
                      done: state.completedPrayers.contains(prayer),
                      enabled: canTickPrayer(
                        viewedDate: state.viewedDate,
                        today: now,
                        now: now,
                        prayerStart: isToday ? _prayerStart(prayer) : null,
                      ),
                      onTap: () => cubit.togglePrayer(prayer),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: context.colors.hairline, height: 1),
              const SizedBox(height: 16),
              SemanticButton(
                label: l10n.fastingTodayLabel,
                checked: state.fastingToday,
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
                    Text(l10n.fastingTodayLabel, style: AppTypography.body(context.colors.ink)),
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
                label: l10n.trackerViewProgress,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const ProgressScreen()),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart, color: context.colors.gold, size: 16),
                    const SizedBox(width: 6),
                    Text(l10n.trackerViewProgress, style: AppTypography.body(context.colors.gold)),
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

