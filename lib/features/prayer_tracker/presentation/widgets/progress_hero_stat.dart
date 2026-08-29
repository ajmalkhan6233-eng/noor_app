// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Progress screen's headline number: a large completion
// percentage for the visible range, plus a plain count of perfect
// days — real visual weight instead of the screen opening straight
// into a chart, per the 2026-08-29 redesign request ("not just a name
// and a blue line").

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';

class ProgressHeroStat extends StatelessWidget {
  const ProgressHeroStat({super.key, required this.days});

  final List<({DateTime date, int completedCount, bool fasted})> days;

  @override
  Widget build(BuildContext context) {
    final totalPossible = days.length * 5;
    final totalDone = days.fold<int>(0, (sum, d) => sum + d.completedCount);
    final percent = totalPossible == 0 ? 0 : ((totalDone / totalPossible) * 100).round();
    final perfectDays = days.where((d) => d.completedCount == 5).length;
    final rangeLabel = days.length == 1 ? 'today' : 'the last ${days.length} days';

    return AppCard(
      child: Row(
        children: [
          Text('$percent%', style: AppTypography.counter(context.colors.gold).copyWith(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('of prayers completed, $rangeLabel', style: TextStyle(color: context.colors.ink, fontSize: 13)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 14, color: context.colors.gold),
                    const SizedBox(width: 4),
                    Text(
                      '$perfectDays perfect day${perfectDays == 1 ? '' : 's'}',
                      style: AppTypography.caption(context.colors.sage),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
