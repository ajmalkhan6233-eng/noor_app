// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Streak milestones and badges, weekly goal, and the month heatmap maths.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_tracker/logic/progress/month_grid.dart';
import 'package:noor/features/prayer_tracker/logic/progress/streak_milestones.dart';
import 'package:noor/features/prayer_tracker/logic/progress/weekly_goal.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('streak milestones', () {
    test('milestones are 3, 7, 30 and 100 days', () {
      expect(kStreakMilestones, [3, 7, 30, 100]);
    });

    test('a milestone is reported only on the exact day', () {
      expect(milestoneReached(3), 3);
      expect(milestoneReached(7), 7);
      expect(milestoneReached(30), 30);
      expect(milestoneReached(100), 100);
      for (final other in [0, 1, 2, 4, 6, 8, 29, 31, 99, 101]) {
        expect(milestoneReached(other), isNull, reason: '$other');
      }
    });

    test('next milestone counts up and ends after 100', () {
      expect(nextMilestone(0), 3);
      expect(nextMilestone(3), 7);
      expect(nextMilestone(7), 30);
      expect(nextMilestone(29), 30);
      expect(nextMilestone(30), 100);
      expect(nextMilestone(100), isNull);
    });

    test('badges come from the best streak and are cumulative', () {
      expect(earnedBadges(0), isEmpty);
      expect(earnedBadges(2), isEmpty);
      expect(earnedBadges(3), [ProgressBadge.threeDays]);
      expect(earnedBadges(8), [ProgressBadge.threeDays, ProgressBadge.sevenDays]);
      expect(earnedBadges(100), ProgressBadge.values);
      expect(isEarned(ProgressBadge.thirtyDays, 29), isFalse);
      expect(isEarned(ProgressBadge.thirtyDays, 30), isTrue);
    });
  });

  group('weekly goal', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('defaults to 30 of 35', () async {
      expect(await const WeeklyGoalStore().load(), 30);
    });

    test('is kept on the device and clamped to 5-35', () async {
      const store = WeeklyGoalStore();
      await store.save(20);
      expect(await store.load(), 20);
      await store.save(99);
      expect(await store.load(), 35);
      await store.save(1);
      expect(await store.load(), 5);
    });

    test('progress fraction and reached', () {
      expect(goalFraction(0, 30), 0);
      expect(goalFraction(15, 30), 0.5);
      expect(goalFraction(40, 30), 1, reason: 'never above 100%');
      expect(goalReached(29, 30), isFalse);
      expect(goalReached(30, 30), isTrue);
      expect(goalReached(35, 30), isTrue);
    });
  });

  group('month grid', () {
    test('September 2026 starts on a Tuesday: one blank before the 1st, Monday first', () {
      final grid = buildMonthGrid(DateTime(2026, 9, 17), const {});
      expect(grid.first[0], isNull);
      expect(grid.first[1]!.date, DateTime(2026, 9, 1));
      expect(grid.every((row) => row.length == 7), isTrue);
      final days = grid.expand((r) => r).whereType<MonthCell>().toList();
      expect(days.length, 30);
      expect(days.last.date, DateTime(2026, 9, 30));
    });

    test('counts are placed on their day and clamped to 0-5', () {
      final grid = buildMonthGrid(DateTime(2026, 2), {
        DateTime(2026, 2, 10): 3,
        DateTime(2026, 2, 11): 9,
        DateTime(2026, 1, 31): 5,
      });
      final cells = {for (final c in grid.expand((r) => r).whereType<MonthCell>()) c.date.day: c.count};
      expect(cells[10], 3);
      expect(cells[11], 5);
      expect(cells[1], 0);
      expect(cells.length, 28, reason: 'Feb 2026 has 28 days; other months leak nothing');
    });

    test('leap February has 29 days; month arithmetic crosses the year', () {
      expect(daysInMonth(DateTime(2028, 2)), 29);
      expect(daysInMonth(DateTime(2026, 2)), 28);
      expect(addMonths(DateTime(2026, 12), 1), DateTime(2027, 1));
      expect(addMonths(DateTime(2026, 1), -1), DateTime(2025, 12));
      expect(firstOfMonth(DateTime(2026, 10, 17, 14)), DateTime(2026, 10));
    });

    test('heat levels: 0, 1, 2-3, 4, 5', () {
      expect([for (var i = 0; i <= 5; i++) heatLevel(i)], [0, 1, 2, 2, 3, 4]);
    });
  });
}
