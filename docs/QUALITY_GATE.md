# Quality gate (2026-10-01)

- `flutter analyze`: **No issues found** (was 30 at start).
- `flutter test`: **454 passed, 0 failed** (was 328 at start of the overnight job).
- No file in `lib/` over 150 lines was created; the ones still over 150 are listed below (all pre-existing single classes; splitting them without a device to verify was judged riskier than leaving them).
- Nothing was run on a physical device.

## Contrast (WCAG ratio on the paper background; test/core/theme_contrast_test.dart)
| Theme | ink | secondary (sage) | accent (gold) |
|---|---|---|---|
| Nebula | 17.50 | 9.54 | 11.55 |
| Dawn | 15.77 | 6.56 | **1.60 (fails 4.5; needs decision, NEEDS_DECISION #9)** |
| Emerald Night | 15.60 | 8.40 | 8.60 |
| Mushaf | 14.83 | 6.36 | 6.98 |
Body text (ink, sage) passes 4.5:1 on paper and card in all four themes; the test enforces it.

## Findings status (docs/FINDINGS.md)
Fixed: 1, 3-16, 19-24, 34, 35, 38-40, 42, 45-47, 49 (31). Partly: 41 (file splits), 48 (contrast test added; Dawn accent left).
Confirmed OK: 50. Report-only / skipped: 2, 17, 18, 25, 26, 27, 28, 29, 30, 31, 32, 33, 36, 37, 43, 44.
Skip reasons: 2, 17, 18, 28, 29, 33, 36, 37, 43, 44 need your decision or touch prayer/Qibla/religious content; 25/26 lazy lists (StaggeredFadeIn needs eager children, ~114 simple tiles); 27 (off-screen tabs already pause tickers - not measured); 30/31 (home date stale after midnight) not fixed, needs a rebuild hook on Home; 32 (progress card refresh while open) not fixed.
Extra issues found by the new 200% text tests and fixed: progress week bars, Support and Feedback screens overflowed.

## Improvements status (docs/IMPROVEMENTS.md)
Done: 1-9, 12-14, 16, 18, 19, 23, 24, 27, 29, 31-33, 35-39, 44-50 (and 20-22 already existed).
Not done: 10 (partial), 11 (global 48dp - layout risk), 15, 17, 25, 26, 28, 30 (partial), 34, 40-43.

## Files still over 150 lines (lib/)
surah_audio_download_service (269), paginated_full_quran_text (254), notification_service (218), compass_service (218), location_onboarding_screen (213), quran_repository (207), app_theme (177), app_color_tokens (169), azkar_repository (168), qibla_cubit (164), prayer_cubit (163), azkar_category (158), azkar_category_icon_painters_a (157), settings_repository (156), surah_audio_button (156), surah_index (155), draggable_floating (152).
