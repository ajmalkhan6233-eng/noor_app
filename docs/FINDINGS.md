# noor polish findings (2026-10-01, base main 5da39c4)

Method: read the code and ran `flutter analyze` / `flutter test`; no device. Items marked (R) are report-only (see docs/NEEDS_DECISION.md or a limit of this environment). Severity: crash / wrong data / looks bad / accessibility / performance / polish.

| # | Sev | File:line | Problem |
|---|-----|-----------|---------|
| 1 | crash | lib/main.dart:19-28 | Startup awaits the encrypted DB before `runApp` with no try/catch; if opening fails the app never leaves the native splash. |
| 2 | wrong data | lib/main.dart:19-28 | One-time wipe of `prayer_completions`/`fasting_days` runs for EVERY install the first time this build starts, so real testers upgrading lose tracked prayers. (R, product decision) |
| 3 | accessibility | lib/app.dart:~137 | App multiplies the OS text scale by 1.15; at 200% OS scale the UI renders at 230%, past what most layouts survive. |
| 4 | accessibility | prayer_tracker_card.dart:62,67 | Previous/Next-day chevrons are 20dp icons with no padding (tap target far under 48dp). |
| 5 | accessibility | display_section.dart:55-70 | Hijri offset +/- buttons are bare 24dp icons. |
| 6 | accessibility | prayer_tracker_card.dart:62,67,134 | Hard-coded English Semantics labels ("Previous day", "Next day", "View your progress"). |
| 7 | accessibility | display_section.dart:~86,127 | Hard-coded English labels: "Theme", "Quran text size", "Hijri offset", "Decrease/Increase Hijri offset". |
| 8 | accessibility | home_quick_toggles.dart:123 | Hard-coded "Silent Mode" label. |
| 9 | accessibility | support_home_card.dart:63,73 | Hard-coded English semantics and dismiss label. |
| 10 | accessibility | prayer_countdown_row.dart:131 | "Current time HH:MM" label is a plain English string and changes every minute (noisy for TalkBack). |
| 11 | accessibility | prayer_loading_skeleton.dart:22, dhikr_loading_indicator.dart:50 | English "Loading…" labels. |
| 12 | looks bad | exact_alarm_prompt.dart:29-42 | Dialog text hard-coded English (Tamil/Sinhala users see English). |
| 13 | looks bad | location_onboarding_screen.dart:162,177 | "Continue" / "Not now" buttons hard-coded English. |
| 14 | looks bad | azkar_screen.dart:133 | "No matching duas found." hard-coded English. |
| 15 | looks bad | milestone_nudge_sheet.dart:51,55 | "Support noor"/"Not now" hard-coded. |
| 16 | looks bad | downloaded_audio_section.dart:64-91 | Section title, button and hint hard-coded English. |
| 17 | looks bad | qibla_cubit.dart:90 | Qibla location error is an English literal in a cubit (screen currently hidden). (R) |
| 18 | looks bad | prayer_tracker_card.dart chips | Prayer names shown from raw English list, not localized. |
| 19 | looks bad | app_theme_mode.dart:14-19 | Nebula/Dawn/Follow system labels hard-coded (only Mushaf/Emerald use l10n). |
| 20 | looks bad | glow_hero_title.dart:45-60 | Animated glow shadow is drawn in every theme, including Mushaf ("no shadows"). |
| 21 | looks bad | app_chip.dart:46-64 | Chip is always 20dp rounded, ignoring the Mushaf square-corner token. |
| 22 | looks bad | ~46 `BorderRadius.circular(` call sites | Hard-coded radii; Mushaf only square for cards/buttons. (partly fixed in polish) |
| 23 | performance | prayer_tracker_repository.dart:67-95 | `currentPrayerStreak`/`currentFastingStreak` run one query per day in a loop. |
| 24 | performance | prayer_tracker_repository.dart:97-112 | `historyForRange` does 2 queries per day in a loop. |
| 25 | performance | surah_index.dart:133-146 | 114 surah tiles built eagerly in a non-lazy `ListView(children:[for…])`. |
| 26 | performance | azkar_category_screen.dart:67-77 | Same eager pattern for each category's items. |
| 27 | performance | glow_hero_title.dart:36-40 | Infinitely repeating animation keeps running while the screen is off-screen in a tab stack. |
| 28 | performance | assets/ (44 MB audio) | Adhan audio 20 MB + Quran audio 23 MB are bundled; dominant APK size. (R) |
| 29 | performance | assets/fonts/CormorantGaramond (1.8 MB) | A 1.8 MB font is bundled for one optional theme. (R) |
| 30 | wrong data | hero_card.dart:25-28 | Gregorian/Hijri date in the home hero is read at build time; stale after midnight until something rebuilds it. |
| 31 | wrong data | sunnah_fasting_card.dart:33 | Same: "today" read once per build. |
| 32 | wrong data | progress_week_bars / progress_card | Card's `DateTime.now()` and the cubit clock are separate; card data is loaded once per open (stale if a prayer is ticked meanwhile). |
| 33 | wrong data | prayer_repository.dart:10 | Imports `package:adhan/src/internal/solar_time.dart` (lint `implementation_imports`); breaks on package upgrade. (R: prayer math) |
| 34 | crash | surah_reader_screen.dart:40, full_quran_screen.dart:45 | `onComplete.listen` subscription never stored/cancelled; callback may run after dispose. |
| 35 | crash | tasbih_cubit.dart:47-56 | `selectDhikr`/`loadSaved` emit after awaits without an `isClosed` check. |
| 36 | polish | progress_screen.dart:41 | Screen talks to the repository directly (architecture rule 6). (R) |
| 37 | looks bad | progress_cubit / tracker edit window | Edit window is 2 days but Progress shows 14; older gaps cannot be corrected. (R) |
| 38 | polish | analyze: privacy_policy_screen.dart (12), settings_screen.dart (2), hero_card.dart (3), nav_icon_painters.dart (3), prayer_row_leading_controls.dart (2), ayah_of_day_card.dart, noor_icon_style.dart | 26 `prefer_const_constructors` infos. |
| 39 | polish | monthly_timetable_row.dart:3 | `dangling_library_doc_comment`. |
| 40 | polish | test/features/quran/quran_bookmark_race_test.dart:13 | Unused import warning. |
| 41 | polish | 29 files > 150 lines | Worst: compass_service.dart 297, surah_audio_download_service.dart 281, paginated_full_quran_text.dart 254, notification_service.dart 218, location_onboarding_screen.dart 211, prayer_tracker_card.dart 210. |
| 42 | polish | android/app/build.gradle.kts:37 | Stale "TODO: Specify your own unique Application ID" comment (ID is already set). |
| 43 | polish | android/app/build.gradle.kts:72-79 | Release build silently falls back to debug signing when no key.properties. (R, needs real keystore) |
| 44 | polish | AndroidManifest.xml:18 | `SCHEDULE_EXACT_ALARM` needs Play declaration; fine for adhan but must be answered in Play Console. (R) |
| 45 | polish | lib/features/settings | No Help/FAQ screen exists. |
| 46 | polish | test/ | No widget test renders every screen in all four themes. |
| 47 | polish | test/ | No golden-path (first run → home → tick prayer → progress) test. |
| 48 | accessibility | contrast (all themes) | Contrast was never verified programmatically for Nebula/Dawn/Emerald; gold-on-paper in Dawn (0xFFFFB703 on 0xFFF7F5F1) is well under 4.5:1. |
| 49 | polish | README.md / CLAUDE.md | Do not mention the new themes, progress card or day-rollover watcher. |
| 50 | polish | privacy check | Network use confirmed limited to `surah_audio_download_service.dart` (`http`), plus external `url_launcher` links; no analytics/ads SDK found in pubspec. (confirmed OK, documented) |

## Areas checked with no defect found
- Tick guard (past days allowed, future blocked, today after start).
- Notification scheduling uses absolute instants, so a timezone change does not shift alarm times.
- Qibla no-sensor path degrades to `unavailable`; compass stream subscriptions are cancelled in `close()`.
- Manifest permissions are all used; `allowBackup=false`; release has R8 minify + shrinkResources.
- l10n: en/ta/si have identical key sets (new keys are English-only in ta/si for now).
- RTL: no RTL UI locale is offered; only 9 physical left/right usages exist.
- Landscape: no orientation lock; not verified on device.
