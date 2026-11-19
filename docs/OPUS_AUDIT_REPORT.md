# OPUS AUDIT REPORT — Noor (19 Nov 2026)
Auditor: Opus 5.5. Read-only. Base: branch fix/launch-blockers-credits-restore-guard (incl. 18 Nov fixes + AGP/Gradle bumps).
Executed: source reading, grep sweeps, manifest/workflow/lockfile inspection, pub.dev changelog + Play policy web checks.
NOT executed: flutter analyze, flutter test, any build, AAB/.so inspection, timing on a real phone. All timings below are from code (fixed durations) or estimates.

## 1. EXECUTIVE SUMMARY
- The app is not slow because of one bug: it is slow by design. A 4.45 s animated splash, a forever-running particle background, and audio that is never prepared before tap.
- Quran has NO per-ayah audio at all. Tapping an ayah toggles a bookmark. Audio is whole-surah only, started cold.
- Two Play-launch risks found that the earlier audits missed: (a) the "Support developer" screen asks for donations via WhatsApp, which Play's Payments policy only allows for tax-exempt charities; (b) a legacy GitHub workflow can overwrite the real database code with an old file that hard-codes the DB password.
- Likely root cause of the "restored ticks" bug found: no `dataExtractionRules` on Android 12+, so device-to-device transfer still copies app data even with allowBackup=false.
- The "simple look + one Rich switch" is cheap: the code already has a `flatSurfaces` token and `motion.dart` already honours `disableAnimations`.
- 16 KB: sqflite_sqlcipher 3.4.1 bundles SQLCipher ≥ 4.10 (post-4.6.1 line), so probably OK. Still must be confirmed on the built AAB.

## 2. SPEED FINDINGS
| # | Delay | Where | Cost |
|---|---|---|---|
| S1 | Animated splash: hold 4200 ms + fade 250 ms, shown on first open and after every 24 h idle | lib/core/constants/splash_config.dart:46,52,58; lib/core/presentation/splash/splash_gate.dart:16; lib/app.dart:134-136 | 4.45 s on the opens that matter most (daily first open) |
| S2 | Extra blank frame while SharedPreferences is read to decide splash | lib/app.dart:47-50; lib/splash_decision_placeholder.dart | ~50-150 ms (est.) |
| S3 | Quran audio cold start: `stop()` then `play(AssetSource)` on tap. audioplayers copies the asset to a cache file on first play, then prepares MediaPlayer. Nothing is preloaded. | lib/features/quran/data/surah_audio_player.dart:59-69 | ~0.5-2 s per first tap on a surah (est.; larger files = slower; Al-Kahf etc. 13 MB set) |
| S4 | No per-ayah audio. Ayah tap = bookmark | lib/features/quran/presentation/widgets/continuous_surah_text.dart:65; ayah_end_mark.dart:35 | feature missing, not a delay |
| S5 | Adhan preview same cold path | lib/features/prayer_times/data/adhan_audio_player.dart:44-48 | ~0.5-1 s (est.) |
| S6 | CosmicBackground repaints every frame forever (90 s repeating controller + CustomPainter) behind Home and More | lib/core/presentation/widgets/cosmic_background.dart:44-47; home_dashboard.dart:121 | constant GPU/battery load, jank on low-end phones |
| S7 | Prayer hero rebuilds every 1 s | lib/features/prayer_times/presentation/widgets/prayer_hero.dart:39-42 | small, but continuous |
| S8 | Other forever-repeating animations: glow title, skeleton, streak flame | glow_hero_title.dart:40, skeleton_box.dart:35, streak_flame.dart:41 | continuous repaint while visible |
| S9 | First Quran open after install: parse + insert 6,236 ayahs + translation backfill (done in isolate + batches, good), prewarm starts 2 s after Home | quran_import_service.dart:71-86; home_dashboard.dart:67; ayah_of_day_card.dart:14 | one-time, a few seconds (est.); acceptable |
| S10 | Fonts 5.9 MB, 3 families (Cormorant, Inter, Amiri) | pubspec.yaml:90-100 | app size; Cormorant only needed for Rich/Mushaf |
| S11 | Visual weight inventory: 4 files with blur, 18 CustomPainters, 11 AnimationControllers, 6 gradient files, 7 BoxShadow files, 26 files using glow/stagger/parallax/kinetic/draggable widgets | lib/core/presentation/widgets/*, motion/* | move all behind Rich switch |

## 3. FIX QUEUE (most important first)

### LAUNCH BLOCKERS
**F1 Donation screen vs Play Payments policy** — HIGH — SONNET
Files: lib/features/settings/presentation/support_developer_screen.dart, send_feedback_screen.dart, settings entry.
Change: remove the donation ask (keep "Send feedback"). Play only exempts tax-exempt donations; WireGuard was removed for a donation link.
Check: grep "donat|payment details" in lib returns nothing. Approval: YES (Aj).

**F2 Delete legacy self-writing workflows** — HIGH — HAIKU
Files: .github/workflows/"update core architecture.yml", "add project docs.yml".
Change: delete both. "update core architecture" decodes an embedded payload and overwrites lib/core/database/database_helper.dart (old version with a hard-coded password), haptics, tasbih, pubspec, .clinerules, then pushes.
Check: `ls .github/workflows` shows noor.yml, build-arm64.yml, web-preview.yml only. Approval: YES.

**F3 Block device-to-device transfer (restored ticks root cause)** — HIGH — HAIKU
Files: android/app/src/main/AndroidManifest.xml:50-51, new res/xml/data_extraction_rules.xml.
Change: add `android:dataExtractionRules="@xml/data_extraction_rules"` excluding all domains for cloud-backup and device-transfer. allowBackup=false does not stop D2D on Android 12+.
Check: merged manifest shows the attribute; phone-to-phone test later. Approval: no.

**F4 Release signing + keystore backup** — HIGH — Aj action
Workflow: .github/workflows/noor.yml:167-208 signs only if RELEASE_KEYSTORE_BASE64 is set; else debug-signed AAB.
Change: Aj re-copies the secret (single-line base64), backs up the .jks + passwords offline, enables Play App Signing.
Check: workflow log line "release keystore decoded"; `apksigner verify --print-certs` SHA-256 matches Play Console upload key. Approval: YES.

**F5 16 KB + merged-manifest cloud check** — MEDIUM — SONNET
Change: add a CI step after `flutter build appbundle`: unzip AAB, run `zipalign -c -P 16 -v 4` and `llvm-objdump -p` on every lib/arm64-v8a/*.so (LOAD align ≥ 2**14); print merged manifest permissions.
Check: step passes; list of permissions attached to the run. Approval: no.

**F6 Battery-optimisation permission** — MEDIUM — HAIKU
File: AndroidManifest.xml:34, MainActivity.kt:113.
Change: remove REQUEST_IGNORE_BATTERY_OPTIMIZATIONS; open ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS (the list page, no permission needed) instead.
Check: manifest grep empty; Settings button still opens the battery page. Approval: YES (if Aj wants to keep the direct prompt, a Play declaration is needed).

### SPEED
**F7 Splash → static, instant** — HIGH — SONNET
Files: lib/app.dart, lib/core/constants/splash_config.dart, lib/core/presentation/splash/*, splash_gate.dart, android values-v31/styles.xml.
Change: delete NoorSequenceSplashView + SplashGate. Native launch screen shows "Bismillah / Noor" (static drawable); first Flutter frame is Home. No hold timer. Keep onboarding logic (app.dart:58-101) intact.
Check: widget test: NoorApp's first pumped frame contains HomeDashboard (or onboarding) with no timers pending; Aj times cold start on phone (< 1 s target). Approval: no (decided).

**F8 Quran audio: preload, instant play** — HIGH — SONNET
File: lib/features/quran/data/surah_audio_player.dart; surah_reader_screen.dart:35-60; full_quran_screen.dart:40-66.
Change: on screen open call `player.setSource(...)` (asset or local file) and keep it prepared; tap = `resume()`; drop the `stop()` before play; pre-cache asset via AudioCache.instance.load in initState.
Check: unit test with fake AudioPlayer asserts setSource in init and resume on tap; on phone tap-to-sound < 1 s. Approval: no.

**F9 Adhan preview preload** — MEDIUM — HAIKU
File: adhan_audio_player.dart:44-48, adhan_preview_cubit.dart.
Change: same pattern as F8 for the selected reciter.
Check: unit test as F8. Approval: no.

**F10 Per-ayah recitation (Athan-style tap ayah → play)** — MEDIUM — OPUS
Files: quran data + reader widgets, download service.
Change: the Moeed Alharthi item is "divided into verses"; use its per-ayah files as an optional per-surah download (bundled only for Juz Amma if size allows). Ayah long-press = bookmark, tap = play.
Check: tests for ayah → file mapping + SHA-256; phone test. Approval: YES (size + new download scope).

**F11 Stop forever-repainting** — MEDIUM — HAIKU
Files: cosmic_background.dart, glow_hero_title.dart, skeleton_box.dart, streak_flame.dart, prayer_hero.dart.
Change: in Simple mode do not mount CosmicBackground; others respect disableAnimations; prayer hero ticks per minute unless < 60 s to next prayer.
Check: widget test with Simple mode: no Ticker active after settle (`tester.binding.hasScheduledFrame == false`). Approval: no.

### SIMPLE LOOK (one Rich switch)
**F12 Add "Rich visuals" switch, default OFF** — HIGH — SONNET
Files: settings data/cubit (new bool `richVisuals`, DB migration v11 with default 0), lib/app.dart MaterialApp builder, new app_color_tokens_simple.dart (light + dark, system colours, flatSurfaces: true), settings_screen.dart.
Change: Simple = system light/dark, flat cards, no blur/glow/particles; wrap app in `MediaQuery(disableAnimations: true)` when OFF (motion.dart:28 and parallax already obey it). Rich = today's Nebula/Dawn/Mushaf/Emerald picker.
Check: theme_harness renders all screens in Simple light/dark; migration test v10→v11; golden of Home in Simple. Approval: no (decided).

**F13 Fonts in Simple mode** — LOW — HAIKU
Change: Simple uses system font for UI text; Amiri only for Arabic. Consider dropping Cormorant if only Rich uses it (saves size).
Check: build size diff in CI log. Approval: no.

### SAFETY / LEGAL
**F14 Privacy policy wording** — MEDIUM — HAIKU
File: lib/features/settings/presentation/privacy_policy_screen.dart:98 + hosted policy page.
Change: name archive.org as the only download host; say it sees the IP address; mention wa.me/Play links open other apps.
Check: text test. Approval: no.

**F15 Audio rights chain** — MEDIUM — Aj action
Doha (Public Domain Mark, anonymous uploader) and Moeed Alharthi (CC BY 4.0 declared by an app account) are UNVERIFIED chains. Hamtramck = consent heads-up. Decide keep/drop. Approval: YES.

**F16 Prayer-time defaults for Sri Lanka** — MEDIUM — SONNET
File: lib/features/prayer_times/data/prayer_settings.dart:33-34 (MWL + Shafi).
Change: compare 12 months for Colombo/Kandy/Jaffna against the ACJU timetable in a test; if off > 2 min, add an "ACJU Sri Lanka" preset (angles/offsets) as default.
Check: table test inside ±2 min. Approval: YES (method choice is religious).

**F17 Public phone number** — LOW — HAIKU
File: support_developer_screen.dart:22 hard-codes a personal WhatsApp number in a public repo. If F1 removes donations, keep only feedback via email. Approval: YES.

### CLEANUP
**F18 Rules files** — MEDIUM — HAIKU
.clinerules:4 (no INTERNET), :16 (app_colors.dart); CLAUDE.md Monetization Timeline (free→paid, impossible on Play); CLAUDE.md "This build is 1.0.0"; CLAUDE.md "Cosmic palette only" must allow Simple tokens. See section 4.

**F19 CI guards that always warn** — LOW — HAIKU
noor.yml offline guard warns on `package:http` (used legitimately by surah_audio_download_service.dart); analyze is continue-on-error. Make analyze blocking; whitelist that one file in the guard.

**F20 Small items** — LOW — HAIKU
android:label "noor" → "Noor" (AndroidManifest.xml:47); add Semantics in add_reminder_dialog.dart and draggable_gesture_area.dart; 17 files > 150 lines (leave until touched).

## 4. CORRECTED RULE SET (replace the conflicting lines)
1. Offline by default. ONE exception: user-started Quran audio download from archive.org (INTERNET + ACCESS_NETWORK_STATE declared only for it).
2. Free forever. No ads, analytics, trackers, IAP, billing, or donation requests inside the app.
3. Default look = Simple (system-like, flat, no animation). Rich visuals (Cosmic tokens, effects) only behind the Settings switch. Tokens live in app_color_tokens*.dart; app_colors.dart is retired.
4. Speed rule: no startup timers, no forever-running animations in Simple mode, audio prepared before the user taps.
5. Version = pubspec.yaml = app_info.dart (test enforces). Feature branch → PR → main. Cloud builds only.
6. Religious text only from Tanzil / Hisn al-Muslim; every audio file needs a documented licence and visible credit if CC BY.

## 5. NOT CHECKED
flutter analyze/test results; AAB contents (.so alignment, merged manifest); real-device timings; Play Console state (testers, identity, declarations); Tamil wording quality; Qibla (out of scope).
Usage: `/usage` is not available in this cloud chat; audit kept to ~30 commands.

---
## ONE-SCREEN SUMMARY
**DONE**
- Full read-only audit, 20 fixes ranked with size + check step
**NOT DONE**
- Tests/build/phone timings (cloud CI needed)
**NEEDS AJ**
- Approve F1 (remove donation ask), F2 (delete old workflows), F4 (keystore), F6, F10, F15, F16, F17

Status: NEEDS YOU
