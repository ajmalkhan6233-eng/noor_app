// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of progress_screen.dart to stay under the 150-line-per-
// file rule. Each row's leading icon distinguishes a perfect day
// (gold check), a partial day (cyan), and a missed day (dim outline)
// at a glance, instead of a plain "3/5" number carrying all the
// meaning.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';

class RecentDaysList extends StatelessWidget {
  const RecentDaysList({super.key, required this.days});

  /// Newest first.
  final List<({DateTime date, int completedCount, bool fasted})> days;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final day in days) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    day.completedCount == 5
                        ? Icons.check_circle
                        : day.completedCount == 0
                        ? Icons.circle_outlined
                        : Icons.incomplete_circle,
                    size: 16,
                    color: day.completedCount == 5
                        ? context.colors.gold
                        : day.completedCount == 0
                        ? context.colors.hairline
                        : context.colors.accentSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      DateFormat.MMMEd().format(day.date),
                      style: TextStyle(color: context.colors.ink),
                    ),
                  ),
                  Text(
                    '${day.completedCount}/5 prayers',
                    style: AppTypography.caption(context.colors.sage),
                  ),
                  if (day.fasted) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.nightlight_round, color: context.colors.gold, size: 14),
                  ],
                ],
              ),
            ),
            if (day != days.last) Divider(color: context.colors.hairline, height: 1),
          ],
        ],
      ),
    );
  }
}
