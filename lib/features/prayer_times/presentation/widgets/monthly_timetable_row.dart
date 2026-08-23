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

/// Short, unambiguous column labels — long enough to read at a glance,
/// short enough that 5 prayers still fit one row without wrapping
/// awkwardly. Replaces the old single-letter labels (F/D/A/M/I), which
/// were too easy to misread against each other.
const Map<String, String> _prayerAbbreviations = {
  'Fajr': 'Fajr',
  'Dhuhr': 'Dhr',
  'Asr': 'Asr',
  'Maghrib': 'Mgh',
  'Isha': 'Isha',
};

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

  // Fixed-width columns (not the previous Wrap, which let each cell's
  // text length shift where the next one started) so every row's
  // Fajr/Dhuhr/Asr/Maghrib/Isha times land in the same horizontal
  // position as the row above and below it.
  Widget _times(PrayerTimesComputed result) {
    return Row(
      children: [
        for (final (name, time) in result.prayerEntries)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_prayerAbbreviations[name] ?? name, style: AppTypography.caption),
                Text(formatClock(time), style: AppTypography.time.copyWith(fontSize: 12)),
              ],
            ),
          ),
      ],
    );
  }
}
