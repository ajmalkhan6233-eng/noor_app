// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'progress_stats.dart';

/// Current streak, best streak and prayers kept this week, side by side.
class ProgressStatTiles extends StatelessWidget {
  const ProgressStatTiles({super.key, required this.stats});

  final ProgressStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        _Tile(value: '${stats.currentStreak}', label: l10n.progressCurrentStreak),
        _Tile(value: '${stats.bestStreak}', label: l10n.progressBestStreak),
        _Tile(value: '${stats.keptThisWeek}/35', label: l10n.progressPrayersKept),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Semantics(
        label: '$label: $value',
        excludeSemantics: true,
        child: Column(
          children: [
            Text(value, style: AppTypography.counter(colors.gold).copyWith(fontSize: 22)),
            const SizedBox(height: 2),
            Text(label, textAlign: TextAlign.center, style: AppTypography.caption(colors.sage)),
          ],
        ),
      ),
    );
  }
}
