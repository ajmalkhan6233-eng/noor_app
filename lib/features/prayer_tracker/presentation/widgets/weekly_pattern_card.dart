// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of progress_screen.dart to stay under the 150-line-per-
// file rule. The AppCard wrapper + range label around WeeklyPatternRow.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import 'weekly_pattern_row.dart';

class WeeklyPatternCard extends StatelessWidget {
  const WeeklyPatternCard({super.key, required this.days});

  final List<({DateTime date, int completedCount, bool fasted})> days;

  @override
  Widget build(BuildContext context) {
    final rangeLabel = days.length == 1 ? 'Today' : 'Last ${days.length} days';
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rangeLabel, style: TextStyle(color: context.colors.sage, fontSize: 12, letterSpacing: 0.4)),
          const SizedBox(height: 16),
          WeeklyPatternRow(days: days),
        ],
      ),
    );
  }
}
