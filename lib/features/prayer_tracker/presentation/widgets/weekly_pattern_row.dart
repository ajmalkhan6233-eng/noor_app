// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One ring per day of the last 7: gold and filled for a perfect 5/5
// day, a cyan proportional ring for a partial day, a dim hairline
// outline for a missed day (0/5) — so completed vs. missed reads at a
// glance, not just as a number. Today's ring gets its own glow border
// so "where am I in the week" is immediate. Built entirely from
// CircularProgressIndicator's built-in arc — no CustomPainter needed,
// stays lightweight.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';

class WeeklyPatternRow extends StatelessWidget {
  const WeeklyPatternRow({super.key, required this.days});

  /// Up to 7 days, oldest first, each with how many of the 5 daily
  /// prayers were completed that day.
  final List<({DateTime date, int completedCount, bool fasted})> days;

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final day in days) _DayRing(day: day, isToday: _isToday(day.date)),
      ],
    );
  }
}

class _DayRing extends StatelessWidget {
  const _DayRing({required this.day, required this.isToday});

  final ({DateTime date, int completedCount, bool fasted}) day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final perfect = day.completedCount == 5;
    final missed = day.completedCount == 0;
    final ringColor = perfect
        ? context.colors.gold
        : missed
        ? context.colors.hairline
        : context.colors.accentSecondary;

    return Semantics(
      label:
          '${DateFormat.EEEE().format(day.date)}: '
          '${day.completedCount} of 5 prayers completed'
          '${day.fasted ? ", fasted" : ""}',
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(3),
            decoration: isToday
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.colors.gold.withValues(alpha: 0.6)),
                  )
                : null,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    value: missed ? 1.0 : day.completedCount / 5,
                    strokeWidth: 3,
                    backgroundColor: context.colors.hairline.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation(missed ? Colors.transparent : ringColor),
                  ),
                ),
                if (perfect)
                  Icon(Icons.check, size: 14, color: context.colors.gold)
                else if (!missed)
                  Text(
                    '${day.completedCount}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.colors.ink),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            DateFormat.E().format(day.date).substring(0, 1),
            style: AppTypography.caption(isToday ? context.colors.gold : context.colors.sage),
          ),
          if (day.fasted) ...[
            const SizedBox(height: 2),
            Icon(Icons.nightlight_round, size: 10, color: context.colors.accentSecondary),
          ],
        ],
      ),
    );
  }
}
