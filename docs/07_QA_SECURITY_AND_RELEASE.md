# noor (نور) — QA, Security & Release

**Status:** Reconstructed from project history, 5 August 2026.

---

## 1. Release blockers (must fix before any Play Store submission)

These three are unresolved as of build 18 and block release:

**1. Database passphrase.** `DatabaseHelper` currently opens the encrypted
SQLite database with a literal placeholder string. This must be replaced
with a passphrase read from Android Keystore-backed secure storage
(e.g. via `flutter_secure_storage` backed by Keystore, generated on first
run, never hardcoded, never logged).

**2. INTERNET permission.** The Android manifest must not request
`android.permission.INTERNET`. This is the mechanism that makes noor's
privacy claim structural rather than promised (ADR-3) — verify it is
absent, not just unused.

**3. `allowBackup`.** `android:allowBackup` must be explicitly set to
`false` in the manifest, so the encrypted local database can't be pulled
via `adb backup` or cloud backup on a rooted/debuggable device.

## 2. Signing

Current APKs are **debug-signed** — fine for sideloading, not acceptable
for Play Store. Release requires:
- A real upload keystore generated and stored securely (not in the repo).
- Gradle release signing config referencing that keystore via CI secrets,
  not a committed file.
- The GitHub Actions workflow updated to sign with the release keystore
  rather than the Flutter debug key.

## 3. Data integrity gates

- Quran text: checksum-verified against the Tanzil Project source before
  display; app refuses to render on failure (see 04_ISLAMIC_ENGINE.md).
  This is a release gate, not just a runtime check — a failed checksum
  should fail CI, not just fail silently on-device.
- **Known issue, unresolved:** the bundled Quran text was pulled from a
  GitHub mirror, not tanzil.net directly, because tanzil.net was
  unreachable from the build environment at the time. The bundled file is
  **Tanzil version 1.0.2**, not the current 1.1 release. This should be
  re-sourced directly from tanzil.net and re-diffed against the current
  version before Play Store submission — a version gap in Quran text is a
  release blocker on the same footing as the checksum check itself.
- Azkar / Hajj-Umrah text in Tamil and Sinhala: gated on finding a licensed
  source. Do not ship generated text to unblock this.

## 4. Testing state

- **Only the Tasbih feature has been human-verified** (run and checked by
  a person). Prayer times, Quran, Azkar, Zakat, Hajj/Umrah, and Qibla are
  written and believed correct but have not had the same verification
  pass.
- No automated test suite beyond scaffolding exists yet (`VT-1` unmet).
  Given the `RA-` religious-accuracy requirements, prayer time calculation
  and Zakat threshold behaviour are the highest-priority candidates for
  actual automated tests, not just manual spot-checks.

## 5. CI architecture guards (current, non-blocking)

The build workflow currently runs two guards as warnings only, not
failures:
- 150-line-per-file check.
- Offline-first check (`grep` for `http`/`dio` imports in `lib/`).

These are advisory. Whether to make them hard-fail gates before Play Store
submission is an open decision — recommended to flip to blocking once the
codebase is stable, so a regression can't slip through unnoticed.

## 6. Play Store prerequisites not yet addressed

- Google Play developer account ($25, one-time).
- Privacy policy (straightforward here, given zero data collection — but
  still required by Play Store policy).
- Store listing assets (icon, screenshots, feature graphic).
