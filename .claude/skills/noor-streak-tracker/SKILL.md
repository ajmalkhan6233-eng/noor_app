---
name: noor-streak-tracker
description: Use for any work on the offline prayer/fasting streak tracker feature.
---

# noor Streak Tracker

## Behavior
Tracks consecutive days of completed prayers/fasting, entirely
offline — local SQLite via DatabaseHelper, no sync, no leaderboard
(a leaderboard would require a backend and is out of scope — see
CLAUDE.md Deferred section for anything social/shared).

## Structure
Streak calculation logic in `logic/`, persistence in `data/`,
StreakCapsule-style display in `presentation/` per noor-design-system.

## Edge cases worth handling explicitly
- What counts as "completed" for a day that's still in progress
  (partial day at time of check)
- Timezone/date-boundary handling for streak day rollover
- Graceful handling of a missed day (streak reset behavior should be
  clear and honest, not silently forgiving in a way that misleads the
  user about their actual consistency)
