// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../logic/progress/streak_milestones.dart';
import 'progress_badges_row.dart';
import 'progress_cubit.dart';
import 'progress_day_sheet.dart';
import 'progress_goal_card.dart';
import 'progress_heatmap.dart';
import 'progress_help_sheet.dart';
import 'progress_range_switch.dart';
import 'progress_ring.dart';
import 'progress_stat_tiles.dart';
import 'progress_stats.dart';
import 'progress_week_bars.dart';

class ProgressCardBody extends StatelessWidget {
  const ProgressCardBody({super.key, required this.state});

  final ProgressState state;

  ProgressStats get stats => state.stats;

  String _line(AppLocalizations l10n) => switch (stats.message) {
    ProgressMessage.start => l10n.progressMsgStart,
    ProgressMessage.keepGoing => l10n.progressMsgKeepGoing,
    ProgressMessage.almostThere => l10n.progressMsgAlmost,
    ProgressMessage.perfectToday => l10n.progressMsgPerfect,
    ProgressMessage.onStreak => l10n.progressMsgStreak(stats.currentStreak),
  };

  String? _milestoneLine(AppLocalizations l10n) => switch (milestoneReached(stats.currentStreak)) {
    3 => l10n.progressMilestone3,
    7 => l10n.progressMilestone7,
    30 => l10n.progressMilestone30,
    100 => l10n.progressMilestone100,
    _ => null,
  };

  void _openDay(BuildContext context, DateTime date) {
    final cubit = context.read<ProgressCubit>();
    showProgressDaySheet(context, date: date, loadPrayers: cubit.prayersOn);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final cubit = context.read<ProgressCubit>();
    final now = DateTime.now();
    final milestone = _milestoneLine(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(l10n.progressCardTitle, style: AppTypography.caption(colors.sage)),
              ),
            ),
            SemanticButton(
              label: l10n.progressHelpButton,
              hint: l10n.progressHelpHint,
              onTap: () => showProgressHelpSheet(context),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Icon(Icons.help_outline, size: 20, color: colors.gold),
              ),
            ),
          ],
        ),
        Row(
          children: [
            ProgressRing(
              done: stats.todayDone,
              semanticLabel: l10n.progressTodaySemantics(stats.todayDone),
              semanticHint: l10n.progressTapRingHint,
              onTap: () => _openDay(context, DateTime(now.year, now.month, now.day)),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Semantics(
                label: l10n.progressPercentSemantics(stats.percent),
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${stats.percent}%',
                      style: AppTypography.counter(colors.gold).copyWith(fontSize: AppTypography.displaySize),
                    ),
                    Text(l10n.progressPercentCaption, style: AppTypography.caption(colors.sage)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ProgressStatTiles(stats: stats),
        if (milestone != null) ...[
          const SizedBox(height: 12),
          Semantics(
            liveRegion: true,
            child: Text(milestone, style: AppTypography.bodyStrong(colors.gold)),
          ),
        ],
        const SizedBox(height: 16),
        ProgressGoalCard(done: stats.keptThisWeek, goal: state.goal, onGoalChanged: cubit.setGoal),
        const SizedBox(height: 16),
        ProgressRangeSwitch(showMonth: state.showMonth, onWeek: cubit.showWeek, onMonth: cubit.showMonthView),
        const SizedBox(height: 16),
        if (state.showMonth)
          ProgressHeatmap(
            month: state.month,
            counts: state.counts,
            today: now,
            canGoNext: cubit.canGoNext,
            onPrevious: cubit.previousMonth,
            onNext: cubit.nextMonth,
            onTapDay: (date, _) => _openDay(context, date),
          )
        else
          ProgressWeekBars(
            counts: stats.last7,
            today: now,
            onTapDay: (date, _) => _openDay(context, date),
          ),
        const SizedBox(height: 16),
        ProgressBadgesRow(bestStreak: stats.bestStreak),
        const SizedBox(height: 16),
        Text(_line(l10n), style: AppTypography.body(colors.ink)),
      ],
    );
  }
}
