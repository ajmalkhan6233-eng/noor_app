// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Pure maths behind the Progress card — no Flutter, no I/O — so the
// streak and percentage rules are unit-testable on their own.

import 'package:equatable/equatable.dart';

enum ProgressMessage { start, keepGoing, almostThere, perfectToday, onStreak }

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
DateTime _dayBefore(DateTime d) => DateTime(d.year, d.month, d.day - 1);

class ProgressStats extends Equatable {
  const ProgressStats({
    required this.todayDone,
    required this.percent,
    required this.currentStreak,
    required this.bestStreak,
    required this.last7,
    required this.keptThisWeek,
  });

  static const empty = ProgressStats(
    todayDone: 0,
    percent: 0,
    currentStreak: 0,
    bestStreak: 0,
    last7: [0, 0, 0, 0, 0, 0, 0],
    keptThisWeek: 0,
  );

  /// Prayers ticked today, 0-5.
  final int todayDone;

  /// Prayers ticked / prayers possible over the last 7 days, counting
  /// only days since the first tick (a fresh install is not "0%").
  final int percent;

  /// Consecutive days with all five prayers, ending today — or
  /// yesterday while today is still in progress.
  final int currentStreak;
  final int bestStreak;

  /// Completed-prayer counts for the last 7 days, oldest first.
  final List<int> last7;

  /// Prayers ticked in the last 7 days.
  final int keptThisWeek;

  ProgressMessage get message {
    if (todayDone >= 5) return ProgressMessage.perfectToday;
    if (currentStreak >= 2) return ProgressMessage.onStreak;
    if (todayDone >= 3) return ProgressMessage.almostThere;
    if (todayDone > 0 || keptThisWeek > 0) return ProgressMessage.keepGoing;
    return ProgressMessage.start;
  }

  factory ProgressStats.compute(Map<DateTime, int> rawCounts, DateTime now) {
    final today = _dayOnly(now);
    final counts = <DateTime, int>{
      for (final e in rawCounts.entries) _dayOnly(e.key): e.value.clamp(0, 5),
    };
    int at(DateTime d) => counts[d] ?? 0;

    final last7 = [
      for (var i = 6; i >= 0; i--) at(DateTime(today.year, today.month, today.day - i)),
    ];

    final active = counts.entries
        .where((e) => e.value > 0 && !e.key.isAfter(today))
        .map((e) => e.key)
        .toList();
    var windowDays = 1;
    if (active.isNotEmpty) {
      final first = active.reduce((a, b) => a.isBefore(b) ? a : b);
      windowDays = (today.difference(first).inDays + 1).clamp(1, 7);
    }
    final inWindow = last7.sublist(7 - windowDays).fold<int>(0, (a, b) => a + b);
    final percent = active.isEmpty ? 0 : ((inWindow / (windowDays * 5)) * 100).round();

    var current = 0;
    var day = at(today) >= 5 ? today : _dayBefore(today);
    while (at(day) >= 5) {
      current++;
      day = _dayBefore(day);
    }

    final perfect = counts.entries.where((e) => e.value >= 5).map((e) => e.key).toList()..sort();
    var best = 0;
    var run = 0;
    DateTime? prev;
    for (final d in perfect) {
      run = (prev != null && _dayBefore(d) == prev) ? run + 1 : 1;
      if (run > best) best = run;
      prev = d;
    }

    return ProgressStats(
      todayDone: at(today),
      percent: percent,
      currentStreak: current,
      bestStreak: best > current ? best : current,
      last7: last7,
      keptThisWeek: last7.fold<int>(0, (a, b) => a + b),
    );
  }

  @override
  List<Object?> get props => [todayDone, percent, currentStreak, bestStreak, last7, keptThisWeek];
}
