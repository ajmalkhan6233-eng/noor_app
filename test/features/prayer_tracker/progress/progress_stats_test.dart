// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/presentation/progress/progress_stats.dart';

// Wednesday.
final _today = DateTime(2026, 9, 30, 14, 30);

DateTime _d(int back) => DateTime(2026, 9, 30 - back);

Map<DateTime, int> _full(Iterable<int> daysBack) => {for (final b in daysBack) _d(b): 5};

void main() {
  group('percentage', () {
    test('no ticks ever is 0% and start message', () {
      final s = ProgressStats.compute(const {}, _today);
      expect(s.percent, 0);
      expect(s.message, ProgressMessage.start);
    });

    test('full week of perfect days is 100%', () {
      final s = ProgressStats.compute(_full([0, 1, 2, 3, 4, 5, 6]), _today);
      expect(s.percent, 100);
      expect(s.keptThisWeek, 35);
    });

    test('18 of 35 prayers over a full week rounds to 51%', () {
      final s = ProgressStats.compute({
        _d(0): 3,
        _d(1): 5,
        _d(2): 2,
        _d(3): 4,
        _d(4): 0,
        _d(5): 3,
        _d(6): 1,
      }, _today);
      expect(s.percent, 51);
    });

    test('only days since the first tick count on a new install', () {
      // First tick 2 days ago: window is 3 days, 9 of 15 = 60%.
      final s = ProgressStats.compute({_d(2): 4, _d(1): 3, _d(0): 2}, _today);
      expect(s.percent, 60);
    });

    test('ticks older than 7 days do not count toward the percentage', () {
      final s = ProgressStats.compute({..._full([10, 11]), _d(0): 5}, _today);
      expect(s.keptThisWeek, 5);
      expect(s.percent, 14); // 5 of 35
    });

    test('a timestamp inside the day still maps to that calendar day', () {
      final s = ProgressStats.compute({DateTime(2026, 9, 30, 23, 59): 4}, _today);
      expect(s.todayDone, 4);
    });
  });

  group('current streak', () {
    test('counts consecutive perfect days ending today', () {
      expect(ProgressStats.compute(_full([0, 1, 2]), _today).currentStreak, 3);
    });

    test('an unfinished today does not break a streak from yesterday', () {
      final s = ProgressStats.compute({..._full([1, 2]), _d(0): 2}, _today);
      expect(s.currentStreak, 2);
    });

    test('a missed day breaks the chain', () {
      expect(ProgressStats.compute(_full([0, 1, 3, 4]), _today).currentStreak, 2);
    });

    test('nothing yesterday and incomplete today is zero', () {
      expect(ProgressStats.compute({_d(0): 4, ..._full([2, 3])}, _today).currentStreak, 0);
    });

    test('streak crosses a month boundary', () {
      final s = ProgressStats.compute({
        DateTime(2026, 10, 1): 5,
        DateTime(2026, 9, 30): 5,
        DateTime(2026, 9, 29): 5,
      }, DateTime(2026, 10, 1));
      expect(s.currentStreak, 3);
    });
  });

  group('best streak', () {
    test('finds the longest run in history, not just the current one', () {
      final s = ProgressStats.compute(_full([0, 1, 10, 11, 12, 13, 14]), _today);
      expect(s.currentStreak, 2);
      expect(s.bestStreak, 5);
    });

    test('is never lower than the current streak', () {
      expect(ProgressStats.compute(_full([0, 1, 2]), _today).bestStreak, 3);
    });

    test('is zero with no perfect days', () {
      expect(ProgressStats.compute({_d(0): 4, _d(1): 4}, _today).bestStreak, 0);
    });
  });

  group('message', () {
    test('perfect today', () {
      expect(ProgressStats.compute({_d(0): 5}, _today).message, ProgressMessage.perfectToday);
    });

    test('running streak', () {
      final s = ProgressStats.compute({..._full([1, 2]), _d(0): 1}, _today);
      expect(s.message, ProgressMessage.onStreak);
    });

    test('three or four today is almost there', () {
      expect(ProgressStats.compute({_d(0): 3}, _today).message, ProgressMessage.almostThere);
    });

    test('some progress this week keeps going', () {
      expect(ProgressStats.compute({_d(2): 2}, _today).message, ProgressMessage.keepGoing);
    });
  });
}
