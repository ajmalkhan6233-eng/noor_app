# Needs your decision (nothing below was changed)

1. **First-launch wipe of tracker data (lib/main.dart:19-28).** The one-time `delete` of prayer_completions/fasting_days runs on every install the first time this build starts, so testers upgrading from an older build lose ticked prayers. It exists to stop OEM-restored databases showing fake progress. Options: keep, or only wipe when the DB looks restored (e.g. rows older than the install date).
2. **adhan internal import (lib/features/prayer_times/data/prayer_repository.dart:10).** Uses `package:adhan/src/internal/solar_time.dart` to detect unreachable Fajr/Isha angles. It works today but can break on an `adhan` upgrade. Prayer maths, so not touched.
3. **Progress edit window.** Prayers can only be edited 2 days back, but Progress shows 14 days. Decide whether to widen the window or label it in the UI.
4. **Qibla screen (hidden).** The location error text in qibla_cubit.dart:90 is an English literal and the compass glitch is unsolved. Qibla maths/behaviour not touched.
5. **Tamil/Sinhala strings for all new UI** (progress card, Mushaf, Emerald Night, Help/FAQ, etc.) are English-only placeholders. Religious wording and translations need your approval/translator.
6. **SCHEDULE_EXACT_ALARM in the Play Console.** Play requires a declaration for this permission; confirm the adhan use-case answer you want to give.
7. **Bundled audio (44 MB) and the 1.8 MB Cormorant font** dominate app size. Moving audio to an on-demand download would change the offline-first rule, so it is your call.
8. **Prayer names in the tracker chips (finding #18)** are the English names from the code. Showing Tamil/Sinhala names is religious wording, so it was left for you.
