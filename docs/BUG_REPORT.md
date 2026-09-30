# noor bug report — 2026-09-30 (base: origin/main e7f2447)

Static review only (no device run). `flutter analyze`: 30 issues (1 warning, 29 info, 0 errors). `flutter test`: 328 passed, 0 failed.

Severity: **crash** / **wrong data** / **looks bad**.

| # | Sev | File:line | What breaks |
|---|-----|-----------|-------------|
| 1 | wrong data | `lib/features/prayer_times/logic/prayer_cubit/prayer_cubit.dart:29,129` | `PrayerState.date` is set to `DateTime.now()` once at construction and never refreshed. No app-lifecycle/midnight hook reloads it (only Settings-close calls `loadSettings`). Left running across midnight, Home/Prayer Times still show yesterday's times and `scheduleNotificationHorizon` (`notification_horizon_scheduler.dart:30`) builds the 7-day horizon from the stale date — later days' adhan alarms are missed. |
| 2 | wrong data | `lib/features/prayer_tracker/presentation/widgets/prayer_tracker_card.dart:53` + `prayer_hero.dart:32` | Tracker tick guard uses `DateTime.now()` per build but `todayTimes` comes from the stale PrayerCubit date (#1), so after midnight "today" Fajr start is yesterday's and a prayer can be ticked before it has actually started. |
| 3 | wrong data | `lib/features/settings/data/settings_repository.dart:69` | `AppThemeModeOption.values.byName(row['theme_mode'])` throws `ArgumentError` on an unknown stored value (e.g. restoring a backup made on a newer build with a new theme, or a downgrade). Settings load fails → crash on launch path. Needs a fallback to `dark`. |
| 4 | crash | `lib/features/prayer_tracker/data/prayer_tracker_repository.dart:19-35,67-95` | `currentPrayerStreak`/`currentFastingStreak` loop one DB query per day with no upper bound. A long (or imported/backup-restored) history means hundreds of sequential queries on every `load()` (every tick). Not a crash today, but a jank/ANR risk as streaks grow. |
| 5 | wrong data | `lib/features/prayer_tracker/data/prayer_tracker_repository.dart:19-26` | `setPrayerCompleted` uses plain `insert` on a `(date,prayer)` primary key. A rapid double-tap (two toggles racing before `load()` returns) can insert twice → `UNIQUE constraint` exception, unhandled in `PrayerTrackerCubit.togglePrayer`. Same for `setFastingDay`. Use `ConflictAlgorithm.ignore`. |
| 6 | wrong data | `lib/features/prayer_tracker/logic/prayer_tracker_cubit/prayer_tracker_cubit.dart:33-38` | `_maxDaysBack = 2` but `ProgressScreen` (`progress_screen.dart:61`) reads 14 days of history; days 3-13 can never be edited, so the on-time/% numbers undercount for anyone who missed logging. By design but unexplained in the UI. |
| 7 | looks bad | `lib/features/prayer_tracker/presentation/widgets/prayer_tracker_card.dart:62,67,134` | Hard-coded English Semantics labels ('Previous day', 'Next day', 'View your progress') — not in l10n, so Tamil/Sinhala screen-reader users get English. ~51 more `label: '…'` literals across `lib/` (e.g. `home_quick_toggles.dart:123`, `support_home_card.dart:63,73`, `prayer_countdown_row.dart:131`). |
| 8 | looks bad | `lib/core/presentation/exact_alarm_prompt.dart:29-42`, `location_onboarding_screen.dart:162,177`, `azkar_screen.dart:133`, `milestone_nudge_sheet.dart:51,55` | ~22 hard-coded English `Text('…')` literals bypassing l10n (ta/si have 318/318 keys in sync with en — the gap is literals, not missing ARB keys). |
| 9 | looks bad | `lib/features/prayer_tracker/presentation/widgets/prayer_tracker_card.dart` (prayer chips) | Prayer names shown from the raw English `trackedPrayers` strings, not localized. |
| 10 | looks bad | `lib/core/sensors/compass_service.dart` (297 lines) and 24 other files | Violates the 150-line rule. Worst: compass_service 297, surah_audio_download_service 281, paginated_full_quran_text 254, notification_service 218, location_onboarding_screen 211, prayer_tracker_card 210, quran_repository 207, database_migrations 185, about_screen 179, azkar_screen 177, app_theme 176. |
| 11 | looks bad | `test/features/quran/quran_bookmark_race_test.dart:13` | Only analyzer warning: unused import `quran_ayah.dart`. |
| 12 | looks bad | `lib/features/settings/presentation/*`, tests | 29 `prefer_const_constructors` infos. |

## Checked, no bug found
- Tick guard (`prayer_tick_guard.dart`): past days tickable, future days not, today only after prayer start; `null` start → blocked. Correct.
- Midnight rollover of the *tracker* date: stored as `daysBack` offset, so it follows real today. Correct (the stale part is the PrayerCubit, #1).
- Timezone: `tz.local` is never set (defaults to UTC) but every schedule converts an absolute instant via `TZDateTime.from(time, tz.local)` with `absoluteTime`, so fire time is still correct. Benign, but any future wall-clock scheduling would be wrong.
- Qibla: sensor absence → single `CompassAccuracy.unavailable` reading; GPS denied → district fallback path exists. Screen is currently routed to "coming soon" anyway.
- Theme switching: `AppThemeController` ValueNotifier drives MaterialApp live; `context.colors` is a ThemeExtension dependency. Correct. Note `MaterialApp` only has `theme`/`darkTheme` (relevant to new themes).
- l10n: en/ta/si all have 318 keys, none missing.

## Not checked
No on-device run. Notification delivery, GPS, compass hardware, OEM backup restore were not exercised.
