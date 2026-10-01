// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'progress_stats.dart';
import 'streak_flame.dart';

/// Current streak (with its flame), best streak and prayers kept this
/// week, side by side.
class ProgressStatTiles extends StatelessWidget {
  const ProgressStatTiles({super.key, required this.stats});

  final ProgressStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Tile(
          value: '${stats.currentStreak}',
          label: l10n.progressCurrentStreak,
          semantics: l10n.progressStreakSemantics(stats.currentStreak),
          leading: StreakFlame(streak: stats.currentStreak),
        ),
        _Tile(value: '${stats.bestStreak}', label: l10n.progressBestStreak),
        _Tile(value: '${stats.keptThisWeek}/35', label: l10n.progressPrayersKept),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.value, required this.label, this.leading, this.semantics});

  final String value;
  final String label;
  final Widget? leading;
  final String? semantics;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Semantics(
        label: semantics ?? '$label: $value',
        excludeSemantics: true,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 4)],
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: AppTypography.counter(colors.gold).copyWith(fontSize: AppTypography.timeLargeSize),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, style: AppTypography.caption(colors.sage)),
          ],
        ),
      ),
    );
  }
}
