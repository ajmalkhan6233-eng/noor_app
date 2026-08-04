// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One day's row in the monthly timetable: date, then the five prayer
// times. Today's row carries the same thin emerald left rule used for
// the current prayer elsewhere in the app.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../data/prayer_times_result.dart';
import '../../logic/monthly_timetable_cubit/monthly_timetable_state.dart';
import 'prayer_time_format.dart';

class MonthlyTimetableRow extends StatelessWidget {
  const MonthlyTimetableRow({super.key, required this.day, required this.isToday});

  final MonthlyTimetableDay day;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final result = day.result;
    final dateLabel = '${day.date.day}/${day.date.month}';
    final timesLabel = result is PrayerTimesComputed
        ? result.prayerEntries
              .map((e) => '${e.$1} ${formatClock(e.$2)}')
              .join(', ')
        : 'unresolved';
    return Semantics(
      label:
          '$dateLabel${isToday ? ', today' : ''}: $timesLabel',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isToday ? AppColors.emerald : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(dateLabel, style: AppTypography.time),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: result is PrayerTimesComputed
                  ? _times(result)
                  : const Text(
                      'No genuine Isha/Fajr this day',
                      style: AppTypography.caption,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _times(PrayerTimesComputed result) {
    return Wrap(
      spacing: 10,
      children: [
        for (final (name, time) in result.prayerEntries)
          Text(
            '${name[0]} ${formatClock(time)}',
            style: AppTypography.caption,
          ),
      ],
    );
  }
}
