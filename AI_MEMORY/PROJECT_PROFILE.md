# PROJECT_PROFILE (written 2026-10-01; from CLAUDE.md, README, pubspec, docs)

## Identity
- Name: noor (pubspec version 1.1.1+3)
- Purpose: offline-first, ad-free Islamic utility app for Android (prayer times, adhan, Quran, Azkar, Tasbih, tracker, calendar, zakat)
- Stack: Flutter/Dart, native Android. State: flutter_bloc/Cubit. DB: sqflite_sqlcipher. Prayer math: adhan pkg
- Owner on GitHub: ajmalkhan6233-eng/noor_app

## Important folders
- lib/features/<feature>/{data,logic,presentation}; lib/core (cross-feature singletons); lib/l10n (.arb)
- assets/ (quran, azkar, audio, database, qibla); test/; docs/; .github/workflows/
- Task/history docs: CLAUDE.md (rules), CLAUDE_HISTORY.md (old diary), docs/NEEDS_DECISION.md, FINDINGS.md, IMPROVEMENTS.md, QUALITY_GATE.md, PLAY_STORE_READINESS.md

## PROTECTED CONTENT (never generate, edit, paraphrase)
- Quran text: Tanzil Project only (assets/quran, quran_translations)
- Azkar/Dua: Hisn al-Muslim only (assets/azkar)
- Any Arabic dua / Tamil / Sinhala religious wording: never invent; flag for Aj
- Adhan audio, Quran audio: no new audio without a confirmed reusable licence + consent
- Prayer maths (prayer_times, adhan usage) and Qibla source: do not touch without Aj's decision
- Encrypted DB + migrations (DatabaseHelper): schema change needs a matching migration

## Never-touch list
- android/key.properties and any keystore/secrets (gitignored; never read into memory files)
- Qibla "coming soon" routing/untouched source until the GPU glitch is traced
- No IAP/billing library, no ads, no analytics, no INTERNET use beyond Quran audio download (surah_audio_download_service.dart)
- Never run `dart format lib`. Never build an APK locally
- Palette locked via AppColorTokens (new themes appended at END of AppThemeModeOption)

## Commands
- Setup: `flutter pub get`; after editing lib/l10n/*.arb: `flutter gen-l10n`
- Check: `flutter analyze` (must say No issues found); `flutter test` (must be green)
- Run / app launch command: unknown for now (docs only say full rebuild + `adb install -r`; hot-reload not usable)
- Play Store status (1.0.0 submitted? live?): unknown for now
- Verified 2026-10-01 after pull: `flutter analyze` = No issues found; `flutter test` = 607 passed, 0 failed (run twice). Nothing run on a device.
- Build APK: ONLY GitHub Action "Build arm64-only APK" on main -> dist/noor-arm64.apk on apk-releases branch
- Release: AAB signed from GitHub secrets; bump pubspec version first; staged rollout in Play Console
- Deploy/Play Store upload: Aj does manually. Details UNKNOWN beyond docs/PLAY_STORE_READINESS.md

## Special rules (from CLAUDE.md)
- Work block by block; name the block first; do not re-audit unrelated features
- Files under 150 lines; UI never touches DB (Cubit -> repository); Semantics on every interactive widget; all text via l10n
- Reports: summary only. Never mark UI done from source reading; needs screenshot/device proof
- Feature branch + PR, not straight to main
- `.clinerules` is OUTDATED (says no INTERNET at all, points to old app_colors.dart). CLAUDE.md wins. Do not edit .clinerules unless Aj asks.
- Deploy: arm64 APK and Web Preview workflows are green; the signing workflow builds with DEBUG signing because RELEASE_KEYSTORE_BASE64 is empty (Aj must fix the secret)
