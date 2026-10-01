// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Progress screen's headline card: today's ring, percentage,
// streaks, a 7-day bar strip and one encouraging line. All data is
// read locally via ProgressCubit.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/prayer_tracker_repository.dart';
import 'progress_cubit.dart';
import 'progress_help_sheet.dart';
import 'progress_ring.dart';
import 'progress_stat_tiles.dart';
import 'progress_stats.dart';
import 'progress_week_bars.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key, this.repository});

  final PrayerTrackerRepository? repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgressCubit(repository: repository)..load(),
      child: BlocBuilder<ProgressCubit, ProgressStats?>(
        builder: (context, stats) => AppCard(
          padding: const EdgeInsets.all(20),
          child: stats == null
              ? SizedBox(
                  height: 96,
                  child: Center(child: CircularProgressIndicator(color: context.colors.gold)),
                )
              : _Body(stats: stats),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.stats});

  final ProgressStats stats;

  String _line(AppLocalizations l10n) => switch (stats.message) {
    ProgressMessage.start => l10n.progressMsgStart,
    ProgressMessage.keepGoing => l10n.progressMsgKeepGoing,
    ProgressMessage.almostThere => l10n.progressMsgAlmost,
    ProgressMessage.perfectToday => l10n.progressMsgPerfect,
    ProgressMessage.onStreak => l10n.progressMsgStreak(stats.currentStreak),
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.progressCardTitle, style: AppTypography.caption(colors.sage)),
            ),
            SemanticButton(
              label: l10n.progressHelpButton,
              hint: l10n.progressHelpHint,
              onTap: () => showProgressHelpSheet(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.help_outline, size: 20, color: colors.gold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Semantics(
              label: l10n.progressTodaySemantics(stats.todayDone),
              excludeSemantics: true,
              child: ProgressRing(done: stats.todayDone),
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
        const SizedBox(height: 20),
        ProgressWeekBars(counts: stats.last7, today: DateTime.now()),
        const SizedBox(height: 16),
        Text(_line(l10n), style: TextStyle(color: colors.ink, fontSize: AppTypography.bodySize)),
      ],
    );
  }
}
