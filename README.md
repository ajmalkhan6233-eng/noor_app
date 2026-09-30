# noor

An offline-first Islamic utility app for Android, built with Flutter: prayer times and adhan,
Quran reader, Azkar/Dua, Tasbih, prayer tracker with a progress card, calendar and zakat
calculator. No ads, no tracking, and your data stays on your phone.

## Features
- Prayer times calculated on the device (method and madhab chosen in Settings), adhan alarms, silent mode
- Quran (Tanzil text, page-turn reader, bookmarks, bundled Juz Amma audio) and Azkar (Hisn al-Muslim)
- Prayer tracker with a progress card: today ring, current/best streak, 7-day bars, help sheet
- Four themes: Nebula (default dark), Dawn (light), Emerald Night (dark green), Mushaf (parchment)
- English and Tamil (Sinhala to follow); Help / FAQ, About and a built-in Privacy Policy
- Encrypted local database, encrypted backup and restore

## Privacy
Fully offline. The single exception is optional, user-initiated Quran audio downloads
(`lib/features/quran/data/surah_audio_download_service.dart`). No analytics or ad SDKs.

## Develop
```
flutter pub get
flutter gen-l10n      # after editing lib/l10n/*.arb
flutter analyze       # must report: No issues found
flutter test          # must be green
```
Do not run `dart format lib` (it reformats the whole repository).

## Build
APKs are built only by the GitHub Action "Build arm64-only APK" (run it on `main`); the
result is published to `dist/noor-arm64.apk` on the `apk-releases` branch. Release AABs are
signed from GitHub secrets (see `CLAUDE_HISTORY.md` for the keystore fix).

## Project rules
See `CLAUDE.md`: block-by-block work, files under 150 lines, `context.colors` tokens only,
every interactive widget has Semantics, all text through l10n, and no religious text is ever
generated (Quran from Tanzil, Azkar from Hisn al-Muslim).

Open items that need a human decision are listed in `docs/NEEDS_DECISION.md`; release
readiness in `docs/PLAY_STORE_READINESS.md`.
