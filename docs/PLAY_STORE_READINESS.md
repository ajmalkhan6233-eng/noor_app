# Play Store readiness (2026-10-01)

Only facts found in the repository are stated as facts. Everything else is TODO.

## Ready (verified in the repo)
- [x] Application id `com.noorapp.noorprayer` (android/app/build.gradle.kts).
- [x] Version 1.1.0+2 (pubspec.yaml); About screen shows the version; a test keeps the two in sync.
- [x] Target SDK 36, compile SDK 36, min SDK 24 (Flutter 3.47.3 defaults via `flutter.*`).
- [x] R8 minify and resource shrinking on for release; proguard rules file present.
- [x] Ships as arm64 APK from the GitHub Action; `flutter build appbundle` path exists in the AAB workflow.
- [x] `android:allowBackup="false"`, encrypted local database (sqflite_sqlcipher, Keystore-backed passphrase).
- [x] Minimal manifest: location (coarse/fine), notifications, exact alarms, boot receiver, notification-policy (Silent Mode), battery-optimisation prompt, INTERNET/ACCESS_NETWORK_STATE (only for optional Quran audio downloads).
- [x] No analytics, ads or crash-reporting SDKs in pubspec.yaml.
- [x] Built-in Privacy Policy, Help/FAQ and About screens (offline).
- [x] Adaptive launcher icon.
- [x] Analyzer: 0 issues. Tests: all passing (see docs/OVERNIGHT_LOG.md for counts).
- [x] English and Tamil UI. New strings added in this pass are English-only in Tamil/Sinhala (TODO translate).

## Still needed (TODO)
- [ ] **Real release keystore.** The Gradle config falls back to debug signing when `android/key.properties` is missing. The AAB workflow signs from four GitHub secrets; `RELEASE_KEYSTORE_BASE64` was recorded as invalid (CLAUDE.md). Whether the current arm64 APK is release-signed is UNKNOWN. Generate/store a keystore and fix the secret. Enrol in Play App Signing.
- [ ] **Privacy policy URL.** Play requires a public URL; the policy text exists only in-app (`privacy_policy_screen.dart`). Host it and review the wording (the in-app link was previously hidden pending your review).
- [ ] **Data safety form answers (draft from the code, confirm before submitting):**
  - Location (approximate + precise): used on device for prayer times; not sent off the device; not shared.
  - No account, no analytics, no advertising ID, no crash reports, no purchases.
  - Network: only optional Quran audio downloads (a plain HTTPS download; no user data sent).
  - Data encrypted at rest on device: yes (SQLCipher). Data deletion: uninstalling removes it; in-app backup files are user-held.
- [ ] **Exact alarm declaration.** `SCHEDULE_EXACT_ALARM` needs a Play Console declaration (adhan alarms); decide the wording.
- [ ] **Store listing assets:** screenshots (phone), 512x512 icon upload, 1024x500 feature graphic, short and full descriptions, category. None are in the repo.
- [ ] **Content rating questionnaire** (IARC) - not done.
- [ ] **Closed testing:** new personal developer accounts must run a closed test with 12 testers for 14 days before production (confirm the current rule in Play Console). Not started.
- [ ] **Staged rollout** for each update (CLAUDE.md reminder).
- [ ] **Target API level**: 36 today; re-check the Play requirement at submission time.
- [ ] **Pricing**: launch free, flip to paid later in Play Console (no IAP, no code change).
- [ ] **Device testing**: nothing in this pass was run on a physical device (adhan alarms, location, notifications, backup/restore, themes at large text). Do a full manual pass before release.
- [ ] Translations for the new strings (Tamil, then Sinhala) and religious-wording review (docs/NEEDS_DECISION.md).
- [ ] Qibla screen is hidden ("coming soon") until the rendering glitch is diagnosed.

## Known risks to decide on (see docs/NEEDS_DECISION.md)
- First-launch tracker wipe (affects upgrading testers).
- Dawn theme accent contrast (1.6:1).
- App size (44 MB bundled audio).
