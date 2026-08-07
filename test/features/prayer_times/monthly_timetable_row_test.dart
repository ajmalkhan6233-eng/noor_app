// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Confirms the fix from single-letter prayer labels (F/D/A/M/I, too
// easy to misread against each other) to short unambiguous
// abbreviations (Fajr/Dhr/Asr/Mgh/Isha).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/data/prayer_times_result.dart';
import 'package:noor/features/prayer_times/logic/monthly_timetable_cubit/monthly_timetable_state.dart';
import 'package:noor/features/prayer_times/presentation/widgets/monthly_timetable_row.dart';

void main() {
  testWidgets('shows short prayer abbreviations, not single letters', (tester) async {
    final day = MonthlyTimetableDay(
      date: DateTime(2026, 8, 7),
      result: PrayerTimesComputed(
        fajr: DateTime(2026, 8, 7, 5, 0),
        sunrise: DateTime(2026, 8, 7, 6, 15),
        dhuhr: DateTime(2026, 8, 7, 12, 30),
        asr: DateTime(2026, 8, 7, 15, 45),
        maghrib: DateTime(2026, 8, 7, 18, 20),
        isha: DateTime(2026, 8, 7, 19, 45),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MonthlyTimetableRow(day: day, isToday: false)),
      ),
    );

    expect(find.textContaining('Fajr'), findsOneWidget);
    expect(find.textContaining('Dhr'), findsOneWidget);
    expect(find.textContaining('Mgh'), findsOneWidget);
    expect(find.textContaining('Isha'), findsOneWidget);
    // Old single-letter format should be gone.
    expect(find.text('F 05:00'), findsNothing);
  });
}
