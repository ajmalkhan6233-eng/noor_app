// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The user's weekly prayer goal (default 30 of the 35 possible in a
// week). Stored in on-device preferences only.

import 'package:shared_preferences/shared_preferences.dart';

const int kPrayersPerWeek = 35;
const int kDefaultWeeklyGoal = 30;
const int kMinWeeklyGoal = 5;

/// Keeps a goal inside the sensible range.
int clampGoal(int goal) => goal.clamp(kMinWeeklyGoal, kPrayersPerWeek);

/// Progress toward [goal] after [done] prayers this week, 0.0 - 1.0.
double goalFraction(int done, int goal) {
  final target = clampGoal(goal);
  return (done / target).clamp(0.0, 1.0);
}

bool goalReached(int done, int goal) => done >= clampGoal(goal);

class WeeklyGoalStore {
  const WeeklyGoalStore();

  static const _key = 'progress_weekly_goal';

  Future<int> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return clampGoal(prefs.getInt(_key) ?? kDefaultWeeklyGoal);
    } catch (_) {
      return kDefaultWeeklyGoal;
    }
  }

  Future<void> save(int goal) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_key, clampGoal(goal));
    } catch (_) {}
  }
}
