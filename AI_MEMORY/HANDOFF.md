# HANDOFF (2026-11-18) — WHERE TO FIND WHAT

## Start here
- Repo: github.com/ajmalkhan6233-eng/noor_app (public). Work branch: fix/launch-blockers-credits-restore-guard (NOT merged yet). main = last commit 2 Oct (v1.1.1+3).
- Read in this order: this file, AI_MEMORY/LIVE.md, AI_MEMORY/OPEN_ITEMS.md, docs/AUDIT_2026-11-18.md.
- Rules: CLAUDE.md wins. .clinerules is STALE (says no INTERNET; points to retired app_colors.dart). Old "free first, paid later" lines in CLAUDE.md and AI_MEMORY/DECISIONS.md are WRONG: Google Play cannot change free to paid. Noor is FREE FOREVER.

## Where things are
- Full audit (permissions, audio, privacy, signing, 16 KB): docs/AUDIT_2026-11-18.md
- Brief given to ChatGPT (product + launch plan): docs/CHATGPT_BRIEF_2026-11-18.md
- Play Store checklist: docs/PLAY_STORE_READINESS.md. Open decisions: docs/NEEDS_DECISION.md
- Audio licences: assets/audio/adhan/README.md, assets/quran/audio/juz_amma/README.md, assets/quran/audio/popular/README.md
- Adhan credits shown in About: lib/core/constants/audio_credits.dart (used by settings/presentation/widgets/about_sources_card.dart)
- Fresh-install data guard: lib/core/database/restored_data_guard.dart (called from lib/main.dart)
- Permissions: android/app/src/main/AndroidManifest.xml. Privacy policy screen: lib/features/settings/presentation/privacy_policy_screen.dart
- Builds: .github/workflows/noor.yml (runs on push to main or by hand: Actions > Build Noor Android APK > Run workflow, pick a branch). Cloud only; never build on the PC.
- Version: pubspec.yaml and lib/core/constants/app_info.dart must match (test enforces). Now 1.1.2+4.

## Decided (18 Nov)
- Free forever. No ads, tracking, billing. Cloud builds only.
- Wipe restored tracker data on fresh installs only (done on the branch).
- Play Console: app uploaded, stuck in closed testing (needs 12 testers opted in for 14 days in a row).

## Not done (next, in this order)
1. Run the branch in Actions; if green, merge to main.
2. Cloud check of the release AAB: 16 KB alignment (sqflite_sqlcipher 3.4.1), merged manifest, signing key (Aj re-copies RELEASE_KEYSTORE_BASE64; back up the keystore).
3. Battery permission REQUEST_IGNORE_BATTERY_OPTIMIZATIONS: justify or remove.
4. Privacy policy: name Archive.org as the download host (it sees the phone's IP).
5. Clean docs: .clinerules, free-to-paid lines, CLAUDE.md "1.0.0".
6. Audio plan: 44 MB bundled (adhan 20, Juz Amma 11, 4 surahs 13). Shrink only after Aj approves. Rights chain for Doha + Moeed Alharthi still UNVERIFIED.
7. Store listing, content rating, Data safety form, 12+ testers (need Android + Gmail).

## UNVERIFIED
flutter analyze/test, AAB build, anything on a real phone, Play Console status.
