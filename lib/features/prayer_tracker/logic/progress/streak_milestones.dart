// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Streak milestones and the badges they earn. Pure logic: badges are
// worked out from the best streak in the on-device tick history, so
// there is nothing extra to store and nothing to sync.

/// Days in a row that get a kind message and a badge.
const List<int> kStreakMilestones = [3, 7, 30, 100];

enum ProgressBadge {
  threeDays(3),
  sevenDays(7),
  thirtyDays(30),
  hundredDays(100);

  const ProgressBadge(this.days);

  /// Streak length (days with all five prayers) that earns the badge.
  final int days;
}

/// The milestone reached exactly by [streak], or null.
int? milestoneReached(int streak) => kStreakMilestones.contains(streak) ? streak : null;

/// The next milestone above [streak], or null once past the last one.
int? nextMilestone(int streak) {
  for (final m in kStreakMilestones) {
    if (m > streak) return m;
  }
  return null;
}

/// Badges earned by a best streak of [bestStreak] days, in order.
List<ProgressBadge> earnedBadges(int bestStreak) => [
  for (final badge in ProgressBadge.values)
    if (bestStreak >= badge.days) badge,
];

/// Whether [badge] is earned at [bestStreak].
bool isEarned(ProgressBadge badge, int bestStreak) => bestStreak >= badge.days;
