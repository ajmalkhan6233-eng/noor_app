# noor — Claude Code Project Directive

## WORKING METHOD — READ THIS FIRST, EVERY SESSION

noor is built and maintained block by block. Each feature (Qibla,
Tasbih, Quran, Azkar, Home, Settings, notifications, etc.) is its own
block, self-contained.

When given a narrow request — "fix X," "change the icon," "Qibla is
broken" — work ONLY inside that one block's files. Do not re-read the
whole app. Do not re-audit unrelated features. Do not re-verify things
already confirmed working in a previous session, unless the request
explicitly asks for a full audit.

Before starting any task, state plainly which single block it belongs
to, and confirm you're staying within that scope.

This exists because broad, unscoped work has repeatedly consumed usage
far faster than the actual size of the request justified. This is now
a permanent operating rule for this project, not a one-time
instruction — it applies to every future session, regardless of who
starts it or how the request is phrased.

## Authoritative Corrected Status — 2026-08-29 (Claude Code correction pass follows below)

The list below was written by an overnight VS Code/Copilot session
working on this same repo, locally, unpushed. A same-day Claude Code
session reviewed every commit against real evidence (live-device
testing, `flutter analyze`/`flutter test`, direct source fetches)
before pushing any of it — see "Claude Code review of the 2026-08-29
overnight commits" further below for the corrections that came out of
that review. Two items in the list below are now known wrong or
incomplete as originally written:

- **"Qibla flicker source-level fix"** — disputed. Live-reproduced the
  blank/blinking compass on-device the same day, after this claim was
  written. Not fixed. See the correction section below.
- **"Host the privacy policy publicly and link it in-app"** — the
  actual publish was reverted (commit `97bbe03`) pending the
  developer's own review of the policy text, per an explicit standing
  instruction from earlier the same day. Not live.

Everything else below this heading, unless specifically corrected
further down this file, held up under review.

### Confirmed Done

- Splash sequence: particles, Bismillah, and NOOR reveal
- Dawn/Nebula theme toggle, including Follow system
- Custom navigation and feature icon set
- Dark-mode text contrast fix
- Fresh-install location prompt: one-time and non-blocking
- Sunnah fasting card on Home
- Battery optimization in Settings, intentionally not onboarding
- Manual per-prayer time offsets
- Religious-content disclaimer on About
- Feedback/report button in Settings
- Exact-position Quran bookmark
- Five selectable Adhan reciters through Settings, previews, and notifications
- Quran recitation audio for bundled Juz Amma
- Database migration through schema version 9, tested
- Amiri font label removed from About
- About page mission statement
- Release signing keystore and Gradle selection (see correction below —
  keystore itself is real and working; the CI half needed a real fix)
- Local AAB build

### Genuinely Open

1. Launcher icon: replace the default Flutter logo
2. ~~Vesak holiday date~~ — resolved, see correction section below.
3. Complete the Sri Lanka 2026 holiday dataset from the official gazette
4. ~~CI pipeline: publish AAB instead of APK~~ — was broken (workflow file
   in the wrong location, never ran), now fixed — see correction below.
5. Host the privacy policy publicly and link it in-app — reverted, not
   done, pending developer review of the policy text.
6. Run a real app-performance profiling pass
7. Investigate the reported Home decoration above Dhuhr on a live device
8. Fix Quran play-button visibility
9. Check for any default Flutter icon elsewhere in-app
10. Redesign Monthly Timetable as a clean table
11. Add and verify the parallax scroll effect
12. **Qibla is still broken** — see correction section below. Not on the
    original 11-item list because the overnight session believed it
    was already fixed; re-opened after live reproduction.

Items 1, 3, 8, 10, and 11 were implemented in individual commits
during the 2026-08-29 overnight pass and held up under same-day
review. Item 2 follows the official Ministry-linked schedule: Vesak is
1 May and Adhi Poson is 30 May — these are two different holidays, not
competing dates for one holiday; do not relabel Adhi Poson as Adhi
Vesak. Items 6, 7, and 9 remain verification items where runtime
evidence is still required.

## Claude Code review of the 2026-08-29 overnight commits

Reviewed all 7 local commits from the overnight session before
pushing any of them (they were sitting unpushed — `origin/main` was
still at the last Claude Code commit, so nothing below was ever live).

- **Qibla — disputed, not accepted as fixed.** Live-reproduced the
  compass blanking to near-nothing on ~70% of rapid screenshot frames,
  same device, same day, after the "fix" commit. Ruled out one real
  hypothesis (disabled Impeller via
  `io.flutter.embedding.android.EnableImpeller=false`, rebuilt,
  reinstalled, retested — no difference, reverted). Root cause still
  open. A `screenrecord` capture (to rule out screencap itself racing
  the compositor) is still queued, blocked on phone availability.
- **CI AAB/signing pipeline was broken, now fixed** (`1c710e9`): the
  overnight session's `build_apk.yml` sat at the repo root instead of
  `.github/workflows/` — GitHub only discovers workflows in that exact
  folder, so it never ran, and nothing was ever actually published by
  it. Removed the dead file; merged its real value (signing from 4
  optional repo secrets) into the existing working workflow
  (`noor.yml`)'s AAB step. Falls back to today's debug-signing default
  until those secrets are added in GitHub repo Settings — doesn't
  break anything by existing.
- **Public privacy policy publish reverted** (`97bbe03`), not because
  the content was wrong, but because publishing it wasn't reviewed
  first — an explicit standing instruction from earlier the same
  session that the overnight session wasn't aware of. The in-app
  `PrivacyPolicyScreen` itself is untouched.
- **Vesak date — actually resolved well.** Found that May 1 (Vesak)
  and May 30 (Adhi Poson) are two separate, real holidays, not
  competing claims about one date — sourced from the Ministry of Home
  Affairs' official 2026 holiday schedule PDF. Same-day review
  attempted to independently verify that PDF directly and got a 403
  (same class of government-site blocking hit earlier trying to reach
  the actual Gazette) — so still not a first-hand primary-source
  read, but this is a materially better, more specific answer than
  anything found before it, and internally consistent. Calendar data
  left as the overnight session set it.
- **Release-signing Gradle config** was actually a same-session Claude
  Code change from earlier the same day that had never been committed
  — the overnight session correctly observed it working in the local
  tree and counted it done without needing to redo it. Committed
  properly now (`1b72f7e`).
- Icon, exact-position bookmark, Adhan reciters, DB migration,
  About-page text, Quran play-button fix, Monthly Timetable redesign,
  parallax scrolling: `flutter analyze` clean, full test suite green
  (218/218). Not yet independently live-verified on-device by Claude
  Code specifically — queued.

## Stack
Flutter (Dart), native Android. NOT web, NOT React, NOT Three.js/WebGL —
ignore any prior doc that says otherwise; this app has no JS runtime.
State: flutter_bloc / Cubit. DB: sqflite_sqlcipher. Prayer math: adhan.

## Non-Negotiable Architecture
1. Offline-first, absolute: zero ad SDKs, zero analytics, zero remote
   network calls, zero INTERNET permission in AndroidManifest.xml.
2. No Play Billing / IAP library, ever. Monetization is handled entirely
   at the Play Store listing level — see Monetization Timeline below
   for the launch-free-then-paid sequencing. Nothing billing-related
   lives in code, and nothing in the app should require network access.
3. Feature-first structure: lib/features/<feature>/{data,logic,presentation}
4. lib/core/ holds only cross-feature singletons: constants, database,
   haptics, location, utils.
5. No Dart file exceeds 150 lines. Split before you hit the limit.
6. UI widgets never call the database or calculation logic directly —
   only through a Cubit/Bloc, which calls a repository.
7. Every interactive widget carries an explicit Semantics() with label,
   value (where relevant), and hint. VoiceOver/TalkBack must work on
   every screen.

## Visual Direction (Cosmic Expansion — reinterpreted for Flutter)
Locked tokens. Do not use Emerald / #0A1912 / #D4AF37 — that palette is
retired, superseded by this one:
- Obsidian background: #05070B
- Card surface: #0D1117
- Gold accent: #FFB703
- Cyan accent: #00F2FE

Glass panels: BackdropFilter(blur ~16) + 1px border at ~20% opacity cyan.
Particle / glow / shockwave effects: CustomPainter or Rive — never
Three.js/WebGL, that stack does not exist in this app. Motion: implicit
animations (AnimatedContainer, flutter_animate) for spring-like easing,
not Framer Motion. See root NOOR file for the full "living universe" art
direction — treat it as intent to translate into native widgets, not as
literal library names.

## Deferred — Not Now (tracked, not scope for this loop)
- Masjid/community directory + chat: real vision, but it's a separate
  app (own backend, own privacy policy, own moderation plan). Do not
  build any part of this inside noor. Revisit only when explicitly
  told to.
- Additional halal revenue ideas beyond the locked model (one-time
  paid app via Play Console, no IAP, no ads — see Monetization
  Timeline below for the launch-free-then-paid rollout). Content
  packs, licensing the codebase to other communities, etc. Not
  scoped, not started.
- Hajj/Umrah guide feature, cut from v1 entirely (2026-08-23 planning
  decision). Not shipping any part of it — Talbiyah, Tawaf/Sa'i
  steps, the guide screens, none of it. The Phase 2 "Umrah Guide
  translation gap" item is moot as a result and has been removed.
  Its source (`lib/features/hajj_umrah_guide/`,
  `lib/features/pilgrimage/`), tests, DB schema, and assets
  (`assets/pilgrimage/`, `assets/talbiyah/`) were fully removed from
  the repo 2026-08-26, per direct request — this was dead weight
  bundled (or nearly so) in every build for a feature with no
  reachable entry point. If this feature comes back, it's a rebuild
  from git history (tag/commit before the removal), not a re-enable.
- Multiple Adhan reciter selection, cut from v1 (2026-08-23). Ship
  with the one default reciter only (see assets/audio/adhan/README.md
  for its provenance/licence). Per-reciter selection UI is deferred,
  not scoped for this loop.
- Streak tracker feature, cut from v1 (2026-08-23). Not scoped, not
  started for this loop.

## Anti-Drift Rule (design changes must be provably different)
Past design requests produced no visible change across ~20-30 attempts.
To prevent a repeat:
- Never mark a design/UI task done from source-reading alone. Take a
  screenshot (or update the GitHub Pages preview) before and after,
  and confirm the diff is real.
- Bump the build stamp (commit hash + run number) on every change so
  "already implemented" can be checked against what's actually
  installed, not assumed from the repo.
- If a requested change doesn't visibly appear after a build, treat
  that as a bug to fix (stale cache, wrong widget referenced, hot
  reload not picking it up) — not as "done, ship it anyway."
- Quote the exact token/value changed (e.g. "gold 0xFFB703 applied to
  CTA border, was AppColors.cardSurface before") in the commit message
  or summary. If you can't name the specific value that changed,
  nothing changed.

## Monetization Timeline (revised 2026-08-24)
Launch **free** on the Play Store listing, not paid — build trust and
reviews first. **Launch window: 1 month** (concrete number set
2026-08-24; previously "an establishing period" — same decision, just
dated). After that month, flip the listing from free to paid in Play
Console. This is a store-level setting change only: no app rebuild, no
code change, nothing in this repo needs to know which mode is active.
Existing installs stay free forever; new installs pay from that point
on. Still locked: no IAP, no billing/subscription library, no ads, no
INTERNET permission, ever — see noor-monetization-guardrails. A later
request to "implement paywall architecture / subscription model
infrastructure" (2026-08-24) was declined for this exact reason — it
would require Play Billing (network + a billing SDK), which
contradicts this app's offline-first, zero-network architecture and
this locked model. If in-app monetization is ever genuinely wanted,
that's a new architecture decision to make explicitly and knowingly —
not something to slide in as a "spec update." This revises (does not
replace) the one-time-paid-app model in the Non-Negotiable Architecture
section above; the destination is the same, only the launch sequencing
changed.

## Language Scope (v1) (added 2026-08-23)
English + Tamil complete for v1. Sinhala follows in a post-launch
update — do not block v1 release on finishing Sinhala translation.
Existing Sinhala strings/infrastructure stay in the repo and keep
being maintained where already present; the gap is in coverage
completeness, not architecture.

## Update & Release Safety
- Every release: bump the version in pubspec.yaml (both the version
  name and the build number) before tagging.
- Ship as AAB, not APK, once Phase 3's AAB migration is done — this is
  what lets the Play Store send users only the changed bytes on an
  update, not the whole app again.
- Any change to the local database schema (new table, new column,
  changed structure) must come with a matching migration in
  DatabaseHelper's upgrade path — never assume a fresh-install-only
  setup is enough once real users have real data saved. An update must
  never silently drop or corrupt someone's existing streak data, Zakat
  settings, or bookmarks.
- All 189+ tests must be green before any release is tagged.
- Recommend a staged rollout in Play Console for every update after
  the initial launch (release to ~10% of users, watch Android Vitals
  for crash reports for a day or two, then expand) — note this is a
  Play Console setting done at publish time, not app code, so just
  flag it as a reminder each release, don't try to build it into the
  app.

## Religious Content
Never generate Quranic text, Arabic duas, or Tamil/Sinhala religious
text. Quran text: Tanzil Project only, verified before commit. Azkar
gaps: cross-check Hisn al-Muslim before adding any new entry. If a
source can't be verified, leave it flagged rather than filling it in.

## Token Efficiency
No conversational filler, no restating the task. Output working code
directly, in complete modular blocks. Stop when the checklist item
below is done — don't scope-creep into the next one uninvited.

---

## Build Loop
Work top to bottom. Commit after each checked-off item. Report status
against this list, not a summary of unrelated work.

### Phase 1 — Fix known breakage
- [x] Al Quran tab stuck on loading spinner — fixed by `cac8419`
      (`.gitattributes` pins Quran/Azkar assets to `eol=lf`; Windows
      CRLF checkout was failing the SHA-256 import gate). Verified
      current working-tree asset hashes match the expected constants.
- [x] Duas & Dhikr tab stuck on loading spinner — same root cause and
      fix as above (`cac8419`).
- [x] Ayah of the Day showing empty despite prior completion report —
      same root cause, plus a real latent gap now fixed: the Home card
      built its own `QuranRepository` without ever calling
      `QuranImportService.ensureImported()`, so on a fresh install
      (before the user opened the Al Quran tab) it stayed empty even
      after `cac8419`. `AyahOfDayCard` now calls `ensureImported()`
      itself before querying.
- [x] Location detection not prompting on first launch — verified:
      `HomeDashboard` eagerly runs `PrayerCubit()..loadSettings()`,
      which falls through to `LocationService.autoFetchCoordinates()`
      and the real OS permission dialog when no district is set yet.
- [x] Every Arabic string (Quran ayat, Azkar, dua text) checked against
      its Tanzil Project / Hisn al-Muslim source — verbatim, no
      re-typing from memory, shadda/diacritic errors specifically
      checked for (see 04_ISLAMIC_ENGINE notes on prior shadda defect).
      Done 2026-08-26 — see "Religious text verification pass" below
      for the independent programmatic re-check (not just trusting the
      asset READMEs) and the real gap it found and fixed (Azkar hadith
      citations weren't rendered in the UI despite being mandatory data).
- [ ] Confirm audio actually plays, per tab, per reciter — not just
      that a play button renders. Root-cause any tab where audio is
      silent; do not close this item on a UI-looks-right check alone

Add a build stamp (commit hash + run number) visible in debug builds.
Past "already implemented" claims have traced back to stale installs —
verify against what's actually on the device, not the source tree.

### Phase 2 — Close out the running polish batch
- [ ] Tasbih orb color / drag behavior
- [ ] Monthly Timetable labels
- [ ] Islamic Calendar: Sri Lankan holidays — kept in v1 (reversed an
      earlier cut, 2026-08-23). Bundled static dataset only: tap a
      date, see what it is — no live lookup, no network. Starter
      reference for 2026, verify/expand against the official gazette
      before building: 26 public holidays total, 13 Poya days;
      Sinhala & Tamil New Year (13-14 Apr), Vesak Full Moon Poya
      (30 May), Eid al-Fitr and Eid al-Adha (moon-sighting dependent —
      mark as approximate/subject to confirmation), Deepavali,
      Christmas (25 Dec).
- [ ] Parallax effects pass
- [ ] Country picker UI
- [ ] About page attribution
- [ ] "Allah" calligraphy emboss treatment
- [ ] Splash screen — Big Bang concept
- [x] Per-prayer alarm toggles — verified 2026-08-25: bell icons in
      `prayer_times_list.dart` on Home already toggle
      `NotificationSettings.forPrayer`, and
      `prayer_notification_coordinator.dart`/`notification_service.dart`
      already skip scheduling for any prayer where it's off. Pre-dates
      tonight, just wasn't checked off.
- [x] Adhan mute toggle — Home's Silent Mode chip
      (`home_quick_toggles.dart`) is this: master on/off for all five
      prayers' ringer silencing. `silent_mode_section.dart` (the old
      per-prayer granular Settings UI) was removed earlier tonight and
      is now dead/unreferenced code — deliberately left in the repo
      rather than deleted, per an earlier-session call. Fixed tonight
      (2026-08-25) so turning the Home chip on also requests the Do
      Not Disturb access it depends on.
- [ ] Proactive location permission prompt
- [ ] App-wide icon weight pass

### Phase 3 — Release readiness
- [x] Database passphrase is Keystore-backed — verified 2026-08-24:
      `database_helper.dart` calls `SecurePassphraseService.getOrCreatePassphrase()`,
      which generates a 256-bit CSPRNG value on first launch and
      stores it via `flutter_secure_storage` (OS Keystore/Keychain).
      No hardcoded/placeholder passphrase exists anywhere in the repo
      — searched directly, not assumed. This item's original TODO
      reference in `database_helper.dart` no longer exists in the
      file; the fix predates this checkbox being ticked. No automated
      test yet covers this (mocking `flutter_secure_storage`'s
      platform channel is nontrivial) — worth adding later, not a
      blocker given the source is unambiguous.
- [ ] Migrate APK build to AAB
- [ ] Release signing keystore generated and stored safely
- [x] Privacy policy page/link added — `privacy_policy_screen.dart`
      exists, linked from About, real accurate content (not a stub):
      covers the no-collection summary, on-device-only location use,
      what's stored locally, the exact permission list, and contact.
      Verified 2026-08-28. Still open, separately, not a code task:
      Play Console submission itself needs the policy hosted at a
      public URL for the store listing — the in-app page alone doesn't
      satisfy that, only the "does the app have one" half of this item.
- [x] Confirm manifest has no INTERNET permission and no billing
      dependency anywhere in the dependency tree — verified 2026-08-28
      by actually running the Gradle manifest-merge task
      (`processReleaseMainManifest`, not just reading the app's own
      `AndroidManifest.xml`) and reading the real merged output at
      `build/app/intermediates/merged_manifest/release/
      processReleaseMainManifest/AndroidManifest.xml`: zero
      `INTERNET` permission. The *debug* merged manifest does show
      `INTERNET` — that's Flutter's own dev-tooling injection for
      hot reload/DevTools on debug builds only, stripped in release;
      worth knowing so a future debug-manifest check doesn't
      misdiagnose it as a plugin leak. `pubspec.lock` has no
      billing/`in_app_purchase`/IAP package of any kind.

### Phase 4 — Submission
- [ ] Google Play developer account registered
- [ ] Listing set to free at launch, per Monetization Timeline above
      (flip to paid, one-time, in Play Console after the establishing
      period — not a launch-day task)
- [ ] Closed testing track live: 12 testers minimum, 14 days
- [ ] Submit for review

Do not jump to a later phase while an earlier item is still open.

### Overnight log — 2026-08-26
Tried to switch from source-reading to live device testing (test adhan
notification, etc.) once told the phone was plugged in and connected.
Blocked: `adb devices` returns an empty list even after finding
adb.exe at `C:\android-sdk\platform-tools\` and restarting the adb
server (`kill-server` / `start-server`). No wireless-debugging
endpoint reachable either (`127.0.0.1:5555` refused). This means
either USB debugging isn't authorized on the phone (needs a tap on
the phone's own "Allow USB debugging?" prompt — can't be done
remotely), the cable/port is charge-only, or the phone is asleep/
locked. Nothing on the PC side left to try without that phone-side
tap. Fell back to `flutter analyze` + `flutter test` + CI for the
rest of the night — see commits `f628185` and `d877923`, both green
in CI (runs #114, #115). First thing to check in the morning: unlock
the phone, accept the USB debugging prompt if one is showing, then
re-run `adb devices` from a terminal to confirm it's seen before
trusting any future "tested live" claim.

### URGENT — app not currently installed on the phone (2026-08-26, ~06:24)
The phone connected and `adb devices` finally saw it (device
`lbzdfer8vkaqiziz`, a Redmi/POCO running MIUI/HyperOS `V816`,
build `OS3.0.302.0.WOGMIXM`). Built a fresh debug APK
(`flutter build apk --debug`, succeeded) to install tonight's fixes
and test live. `flutter install` first tried a release APK that
didn't exist, and in the process **uninstalled the previously
working build** (confirmed: `adb shell pm list packages | grep noor`
now returns nothing — the app icon is gone from the home screen).
The follow-up `adb install -r app-debug.apk` then failed immediately
with `INSTALL_FAILED_USER_RESTRICTED: Install canceled by user` — no
on-device confirmation dialog ever appeared (checked via screencap
mid-install), so this isn't a tap-to-confirm prompt being missed.
This is MIUI/HyperOS's own "Install via USB" developer-option gate,
separate from Android's "Unknown sources" setting (which is already
correctly enabled — `install_non_market_apps=1`). It fails silently
before any dialog when that specific toggle is off.

**To fix, on the phone itself:** Settings → Additional settings (or
"Privacy protection") → Developer options → find "Install via USB"
and turn it on. MIUI/HyperOS may require signing into a Xiaomi/Mi
account and a phone-side verification step the first time — this
can't be done remotely, needs Ajmal's hand. Once that's on, re-run
from this machine:
`"/c/android-sdk/platform-tools/adb.exe" install -r "C:\Users\Sony\Documents\noor_app\build\app\outputs\flutter-apk\app-debug.apk"`
That APK already has tonight's fixes built in (fake_async dependency,
deprecated Matrix4 calls, Silent Mode DND-access regression, and the
ringer-mode restore fix) and is sitting on disk ready to install the
moment that toggle is flipped — no rebuild needed.

### Live device testing session — 2026-08-26, ~06:43–07:25
"Install via USB" got enabled and the debug APK installed successfully.
Real testing on Ajmal's actual phone (Redmi/POCO, MIUI/HyperOS), not
just source reading:

- **Confirmed working live**: the Android 13+ POST_NOTIFICATIONS
  permission dialog fires correctly on first launch (tonight's earlier
  fix) — screenshotted, tapped Allow. Test Adhan from Settings posts a
  real system notification with the correct per-prayer sound resource
  (`android.resource://com.noorapp.noor/raw/adhan_isha`), HIGH
  importance, confirmed via `adb shell dumpsys notification`. The
  Silent Mode chip's DND-access request opens the real system "Modes
  access" (MIUI's name for notification policy access) screen — also
  confirmed via `adb shell dumpsys notification`.
- **Found and fixed live**: `daily_goals_list.dart` — with no location
  set, every prayer on Home's "Today's Spiritual Goals" was markable
  regardless of whether it had actually happened yet (user's own
  words: "now I can select all the prayers... not satisfied"). Fixed,
  commit `0aca166`, verified live afterward — tapping a not-yet-due
  prayer now does nothing.
- **Found and fixed live**: `home_quick_toggles.dart` — the Silent
  Mode chip flipped to "on" (gold, enabled) the instant it opened the
  system DND-access screen, before the user had actually granted
  anything. Confirmed by watching it happen: toggle went gold
  immediately on tap, before I'd touched the system permission screen
  at all. If someone backs out of that screen without granting access,
  the app would still claim Silent Mode is on while the native ringer
  change silently has no effect. Fixed to wait for app-resume and
  re-check real grant state before enabling; 3 tests updated/added,
  all passing.
- **Test artifact, not a bug**: Home's daily-goals checklist currently
  shows all 5 prayers checked for today — that's leftover from my own
  mis-taps during earlier coordinate-calibration mistakes (tapping
  before realizing screenshot preview coordinates need ×1.2 to map to
  the real 1080×2400 device), not a live app bug. Harmless test
  pollution; safe to ignore or clear via Settings if it's confusing to
  look at.
- **Ruled out**: the Progress screen (Prayer Times tab → "View your
  progress") loads instantly and correctly on the real device — not
  the "one is not loading" complaint. The `974ff56` hardening (no
  infinite spinner on a DB read failure) is still worth keeping, but
  wasn't the actual bug the user hit. What was "not loading" is still
  unidentified — no crashes found in logcat across this whole session
  either, so it may have been something transient, or a screen not
  checked yet (Al Quran/Duas & Dhikr both spot-checked fine tonight;
  Monthly Timetable and Qibla weren't tried).
- Also found and fixed live: Silent Mode chip showed "on" before DND
  access was actually granted — see commit `80c97ab`.
- Did not touch Qibla — briefly landed on it by a mistap and backed
  out immediately without investigating, per the standing instruction
  to leave it alone.

**Workflow note, superseded below**: ~~for pure Dart/UI changes, use
`flutter run` with hot reload instead of a full rebuild~~ — tried
this properly (FIFO-bound stdin to `flutter run`, then `flutter
attach`) and confirmed it's a dead end in this environment: Flutter's
interactive `r`/`R` keystroke listener only activates when stdin is a
real terminal (`stdin.hasTerminal`), which nothing here provides — no
PTY available to the tools in this session. `flutter attach` also
independently failed after the driving `flutter run` process was
killed, since that tears down the app's Dart VM debug service even
though the Android app process itself keeps running. **Settled
answer: `flutter build apk --debug` + `adb install -r` for every
change, Dart or native.** ~1 minute per cycle, reliable. Don't
re-attempt hot reload — this is now captured as its own skill
(`.claude/skills/noor-build-and-deploy`), no need to re-litigate.

### Session lessons merged as skills — 2026-08-26, ~08:25
Four new skills added from `noor_lessons_skills.zip` (commit
`f6ffd06`): `noor-android-runtime-permissions` (the POST_NOTIFICATIONS
class of silent-failure bug), `noor-build-and-deploy` (the hot-reload
dead end above, plus: killing a `flutter run`/`attach` process can
leave orphaned `dart.exe`/gradle `java.exe` processes behind that
silently hang the *next* `flutter analyze`/build — check `tasklist`
for stray `dart.exe`/`java.exe` and kill them if a command hangs with
no output for unusually long), `noor-audit-reconciliation` (check
external bug-list items against actual current code before touching
anything — some are already fixed), and `noor-live-device-interaction`
(always re-screenshot immediately before calculating a tap coordinate,
never reuse an older one — this is exactly what caused several
mis-taps earlier tonight). Applied immediately: found 5 orphaned
`dart.exe` (one at 1.4GB) and 1 orphaned `java.exe` gradle daemon
left over from tonight's flutter run/attach experiments, killed them,
confirmed the app relaunches cleanly on the phone, and confirmed
`flutter analyze` runs clean again (120s, only the known low-value
`prefer_const_constructors` info hints, nothing new).

### Support screen silent-failure fix — 2026-08-26, ~08:35
Found the same "silently does nothing" bug class the new
`noor-android-runtime-permissions` skill describes, but from a
different root cause: `support_developer_screen.dart`'s WhatsApp and
email buttons called `canLaunchUrl()` and just no-opped with zero
feedback if it returned false — indistinguishable from a broken tap.
Fixed (commit `5779446`) to show a SnackBar explaining what happened.
Verified via `flutter analyze` + full `flutter test` (213 passing)
and installed live on the phone (`adb install -r`, succeeded) — not
individually tap-tested on-device since it's a low-risk UX-only
change and the phone is being disconnected from here on (per the
user's own request — the phone was only ever needed for live install/
verification, never for editing itself, since hot reload was already
a confirmed dead end).

### More skills added — 2026-08-26, ~09:05
- `noor-hajj-umrah-guide` skill's "known open item" (translation gap)
  turned out to be moot: the whole Hajj/Umrah/pilgrimage feature is
  cut from v1 (confirmed against this file's own Deferred section and
  `more_screen.dart`'s comment) — nothing to fix, nothing reachable
  from the shipped app.
- `noor-prayer-row-ux` (from `noor_prayer_ux_skill.zip`, commit
  `8b835fc`): competitor-research UX patterns for the Prayer Times row
  — live countdown inside the active row, inline per-prayer mute icon,
  simple Today ←/→ date nav. Explicitly NOT including a weekly bar-
  chart tracker (too close to the already-cut streak tracker feature —
  would need its own explicit scope decision). Installed but not yet
  implemented: this is a visual/design change, and the phone is
  disconnected — implementing UI changes blind, with no way to
  screenshot-verify they actually render correctly, would violate the
  project's own anti-drift rule. Apply this the next time the Prayer
  Times row UI is refined with device access available.

### Source-level audit pass — 2026-08-26, ~09:10 (source+test verified only, no device)
Checked and confirmed clean, no action needed: Zakat calculator's core
math (`zakat_calculator.dart` — nisab/rate correct, lower-of-two-metals
logic sound), Calendar screen (no I/O beyond a mounted-checked settings
load), Monthly Timetable's coordinate guard (false alarm — the button
itself is already disabled via `onPressed: null` when no coordinates,
so the redundant guard inside is dead-but-harmless, not a live bug),
`ayah_of_day_card.dart`'s FutureBuilder (already degrades to a "not
loaded" message on error rather than spinning forever), Licences
screen's FutureBuilder (theoretically same stuck-spinner shape as the
Progress-screen bug, but `LicenseRegistry.licenses` is static Flutter
framework data that doesn't do I/O — not worth hardening, todo-listed
here rather than silently skipped), and — the big one —
`settings_repository.dart` against `settings_schema.dart` and
`database_migrations.dart`: every one of `AppSettings`'s 14 fields
round-trips through matching column names in both save() and load(),
the fresh-install schema and the versioned upgrade path
(`latestSchemaVersion = 6`, five upgrade branches) agree exactly, and
there's a dedicated `migration_test.dart` already exercising it. No
gaps found.

This closes out the areas flagged as unexplored earlier tonight. Next
useful work is likely either implementing `noor-prayer-row-ux` (needs
device access) or continuing to spot-check more peripheral screens
not yet looked at (Islamic Calendar occasion data, notification
channel setup on the Kotlin side) if nothing else comes up.

**From this point in the session, the phone is disconnected.** Every
fix below is verified via `flutter analyze` + `flutter test` only,
explicitly noted as such — not live-tested on real hardware. Continue
per the user's standing instruction: work independently, keep this
log current, don't wait for input unless something is genuinely
broken and blocking.

### Regression test added — 2026-08-26, ~09:15
`daily_goals_list.dart`'s gating fix (commit `0aca166`) had zero test
coverage despite being a real correctness bug found live. Added
`test/features/home/widgets/daily_goals_list_test.dart` covering all
three cases: no location set, a not-yet-due prayer with known times,
an already-due prayer with known times (commit `80844ea`). 216/216
tests passing.

### Brief live spot-check — 2026-08-26, ~09:40
Phone reconnected briefly. Installed the latest debug build (all of
tonight's fixes through commit `80844ea`) and did one quick check per
the user's request to keep this efficient rather than exhaustive: the
very first screenshot right after `am start` showed the phone's home
screen/app drawer instead of noor, which looked alarming, but `adb
logcat` showed no crash (`FATAL`/`AndroidRuntime`) anywhere — just an
unrelated benign system `DeadObjectException` from Android's own
baseline-profile installer. A `pm list packages` + relaunch confirmed
the app was still installed and running; the next screenshot showed
Home loading correctly with everything intact (today's prayer times,
the (still stale-from-earlier-testing) spiritual goals checkmarks,
Silent Mode chip). Conclusion: a one-off timing artifact from the
force-stop/relaunch race, not a real bug — noted here rather than
silently dismissed, in case it recurs. Back to source-only work now.

### CRASH found and fixed live — 2026-08-26, ~11:39
This one is more serious than tonight's other fixes — an actual
reproducible crash, not a UX polish item. Live-testing the Azkar tab
(Duas & Dhikr → Morning), tapping a "Tap to count" button to complete
it threw a real Flutter red-screen error: **"setState() or
markNeedsBuild() called during build."** Root cause:
`ParticleBurst.play()` (`core/effects/particle_burst.dart`) calls
`overlay.insert(entry)` synchronously, and every caller triggers it
from `didUpdateWidget` — Tasbih orb, Qibla compass area, the Azkar
counter, and streak milestones all use this exact pattern (per their
own skill files). `didUpdateWidget` runs during Flutter's build
phase; `overlay.insert()` calls `setState()` on the ancestor
`OverlayState` synchronously, and when that Overlay is itself
mid-build in the same frame — routine when a `BlocBuilder` rebuild
cascades down to the widget — that trips the assertion and crashes.

Fixed centrally in `particle_burst.dart` (commit `c082034`): the
`overlay.insert()` call is now deferred via
`WidgetsBinding.instance.addPostFrameCallback`, which fixes every
caller at once rather than patching each call site. All 216 tests
pass, including `tasbih_orb_test.dart` which exercises the same code
path. **Live-verified the actual fix**, not just tests: rebuilt,
installed, reproduced the exact scenario that crashed before (a
fresh "0 of 1" Ayat al-Kursi dhikr, tapped its counter) — this time
it correctly shows "Done · 1 of 1" with the particle burst playing,
no crash, confirmed clean in `adb logcat` too.

This was very likely already happening silently in production before
tonight, on the Tasbih counter and anywhere else a milestone/done
particle burst fires during a cascading rebuild — worth keeping an
eye on whether this explains any past "app crashed" report that
never got a clear repro.

### Every ParticleBurst.play() caller audited — 2026-08-26, ~12:40
Grepped every call site to confirm the central fix actually covers
all of them: `azkar_item_tile.dart`, `tasbih_orb.dart`,
`qibla_compass_area.dart`, `daily_goals_list.dart` (this one wasn't
even on the radar before — marking the last of 5 prayers done would
have hit the exact same crash), `pilgrimage_counter_button.dart` and
`completion_step_view.dart` (unreachable, feature cut, but harmless).
All funnel through the one fixed function. The only
`showModalBottomSheet` in the app (`calendar_screen.dart`) is called
from an `onTap` event handler, not `build`/`didUpdateWidget`, so it
was never at risk. No further Overlay-during-build bugs found.

Tried to live-verify the Tasbih counter's particle burst specifically
(same code path, not yet directly tested) but **the phone's screen
lock is active** — a lock/fingerprint icon is showing, so `adb`
cannot proceed past it. Did not attempt to bypass this — that's
correctly outside what an automated session should do. This is
already inferred safe from the Azkar live-test + `tasbih_orb_test.dart`
passing, just not independently confirmed live yet. Unlock the phone
to let this (and anything else) resume being live-tested.

### winpty re-tested for hot reload — 2026-08-26, ~13:40 (settled, still no)
Re-checked the hot-reload dead-end with a genuinely different mechanism
from the earlier FIFO-stdin attempt: `winpty` (bundled with Git for
Windows, confirmed present at `C:\Program Files\Git\usr\bin\winpty.exe`),
which allocates a real Windows console via a helper process rather than
just piping stdin. Worth the re-test since it's not the same technique
already ruled out — but it hits a *different* wall at an earlier stage:
`winpty` itself refuses to start unless **its own** invoking stdin is
already a real tty. Confirmed with the simplest possible case, no
Flutter involved: `winpty cmd /c "echo hello"` fails immediately with
`stdin is not a tty` — same result whether stdin was the FIFO or
totally unredirected. `winpty --help` has no flag to bypass this check.

Conclusion: this tool session's shell has no real terminal at any
layer, so winpty can't bootstrap one for a child process either. This
isn't fixable by choosing a different wrapper — it would need the
*outer* process invoking commands in this session to itself be a real
console/PTY, which is outside what's available here. `noor-build-and-deploy`
already documents the settled answer (`flutter build` + `adb install -r`
per change); this confirms it holds for winpty too. No further PTY-wrapper
tools are worth trying without first confirming they don't share the
same "own stdin must already be a tty" requirement.

**Correction, same day ~14:00**: the first report of this test claimed
no stray processes were left behind — that was wrong, caught by a
direct follow-up question ("are you currently running any Flutter
command?"). Both winpty attempts *did* spawn a real orphaned
`flutter run -d windows` process tree (`cmd.exe` → `flutter.bat` →
`dartvm.exe`/`dart.exe`, plus a `dart pub get --example` side-process)
that kept running detached for ~10 minutes after winpty itself printed
`stdin is not a tty` and exited — winpty dying did not take its child
down with it. No app window ever appeared in that time (checked via
window titles), so it was stuck, not silently working. Found via
`Get-CimInstance Win32_Process` (PowerShell) filtered on `dart.exe`/
`cmd.exe` with `flutter` in the command line, and killed via
`Stop-Process`. Lesson: after any `winpty`/PTY-wrapper experiment,
verify with the process command line, not just `tasklist` for the
wrapper's own name (`winpty-agent.exe` never appeared, which is what
led to the wrong "nothing spawned" conclusion) — check for the actual
child binary (`dart.exe`, `dartvm.exe`) with the target command in its
`CommandLine`.

### Religious text verification pass — 2026-08-26, ~13:20-14:00
Ran the Phase 1 "every Arabic string checked" item for real, not from
memory — cross-checked the actual shipped asset bytes against what
each README claims, independently, rather than trusting the README:

- **Quran** (`assets/quran/tanzil-uthmani.txt`): programmatically
  confirmed all 6236 ayah lines contain only Arabic-block characters,
  surah/ayah counts match canonical values (114 surahs, 1:7, 2:286,
  114:6), the documented Surah 95/97 double-shadda fix is present in
  the shipped file, and Ayat al-Kursi (2:255) matches the known-correct
  Tanzil Uthmani rendering. Live device: Al-Fatiha renders cleanly in
  the Al Quran tab, no tofu/truncation, correct per-ayah translation.
- **Azkar** (all 4 JSON assets): item counts independently verified
  against the README's claimed coverage (34 morning/evening; 8/15/1
  after_prayer/sleep/travel; 1/5/6/2/1 for the 5 newest categories) —
  all match exactly. Live device: Illness category renders cleanly.
- **Splash Bismillah** (`AppStrings.splashGreeting`): differs from the
  Tanzil source string only in combining-mark *order* (fatha/shadda
  swapped at 3 points) — confirmed via Unicode NFC/NFD normalization
  that both strings are canonically equivalent, so this renders
  identically and is not a real defect.
- **Real gap found and fixed**: `AzkarItemTile` never rendered
  `item.source` — the hadith citation is a mandatory, NOT NULL field
  in the schema and every dataset README claims it's "shown in the UI
  under every dhikr," but the widget only ever displayed Arabic/
  transliteration/translation. `PilgrimageDuaCard` (unreachable,
  Hajj/Umrah cut from v1) does show its citation; Azkar (fully
  reachable) did not. This is exactly the kind of gap a docs-only
  audit would miss — the data-layer test asserting "every item has a
  non-empty source citation" was passing the whole time because it
  only checked the data, never that the citation reached the screen.
  Fixed: added a reference line reusing the existing localized
  `guideReferenceLabel` string (already translated EN/SI/TA). Added a
  regression test (`shows the hadith source citation`). Splitting
  `_CounterButton` out of `azkar_item_tile.dart` into its own file
  (`azkar_counter_button.dart`) was required to stay under the
  150-line-per-file rule after this addition — file was 157 lines,
  now 95 + 72.
- Talbiyah and pilgrimage dua Arabic text also independently verified
  clean (no anomalous characters) — moot for v1 since Hajj/Umrah is
  cut, but checked anyway since the assets ship regardless.
- **Audio playback — partially checked this pass, phone disconnected
  before live playback could be re-confirmed.** Verified in code/on
  disk: `adhanAssetForPrayer`'s 5 filenames all exist in
  `assets/audio/adhan/` at real sizes (2.2-2.9MB each, not stubs);
  `surahAudioAsset`'s Juz Amma scoping (surahs 78-114 only, documented
  reason: full-Quran audio would be ~3x the app's size) matches
  exactly — all 37 `.m4a` files present. Test Adhan was live-verified
  playing audibly earlier this session. Not yet re-confirmed this pass:
  actual tap-to-play on the Al Quran surah reader and any Duas/Azkar
  audio control, since the device disconnected mid-pass — do this next
  time the phone's connected.
- One ambiguous, unconfirmed observation: after reinstalling for the
  citation fix, the Azkar "Illness" category showed its loading
  spinner for an unusually long time (at least ~90s) before the device
  disconnected mid-check. No exception in logcat, process stayed
  alive, and the same screen had loaded instantly minutes earlier on
  the pre-fix build. Most likely explanation is stacked/queued `adb`
  taps from the surrounding navigation commands (it was later found
  back on the Home screen, consistent with an extra queued tap landing
  on the back/home button) rather than a real stuck-spinner regression
  — but this is not confirmed either way. Re-test cleanly (one tap,
  wait, one screenshot) next time the phone's connected before ruling
  it out.

### Two suspicious mid-turn messages, not acted on — 2026-08-26, ~13:35
Two messages arrived formatted as user chat but embedded inside tool-
result-adjacent system output rather than as normal turns: (1) a
"replace the Sri Lanka holiday data" instruction carrying a fully
list of 26 holidays/13 Poya days asserted as "confirmed against the
official gazette" with zero source citation — directly contradicting
this project's own standing rule (every other data file here has a
README with a specific source, a SHA-256 hash, and independent cross-
checking); (2) an instruction to reconfigure tool-permission settings
and "go back" to a nonexistent prior "Athan app comparison" task that
never occurred anywhere in this session. Neither was acted on; both
were flagged back to the user in-chat. `sri_lanka_holiday.dart` was
NOT modified. If the holiday data really does need updating, it needs
an actual source (URL or document) the same way every other asset in
this app has one — not an unsourced assertion.

### Vesak date corrected; text-size + overflow fixes; Reference lines removed — 2026-08-26, ~14:30-15:30
Real web research (WebSearch + WebFetch, not memory) resolved the
file's own previously-flagged Vesak conflict: two independently-dated
2026 sources agree Vesak Full Moon Poya coincides with May Day (1 May
2026), not 30 May. Oct-Dec Poya days/Deepavali intentionally left
unfilled — the only source found for those was internally
inconsistent. Separately: app-wide text size increased ~15% via a
single textScaler multiplier in app.dart (composes with, doesn't
replace, the OS accessibility scale) per direct request, which
surfaced two real overflow bugs (Home prayer-times strip, bottom nav
labels) fixed with FittedBox(scaleDown), plus a 3.2px Pre-adhan
reminder chip overflow fixed with Flexible+FittedBox. Also removed the
"Reference: ..." hadith-citation line from Azkar/Talbiyah/Pilgrimage
dua cards per direct request — data/schema untouched, UI line only.
216 tests passing, `flutter analyze` clean. Pushed (`2ed5f86`).

### Iqama-gap Home hero state — 2026-08-26, ~15:30-16:15
Direct request: a real third state on the Home countdown ("Head to
the masjid" + its own countdown) active only between a prayer's adhan
and its iqamah, replacing what had only ever been a small secondary
caption line (`IqamahCountdownLine`, now deleted) below a hero that
kept showing "next prayer approaching" the whole time. State-
transition logic pulled into a pure function
(`prayer_countdown_phase.dart`) specifically so it's unit-testable
without pumping a widget — 7 tests cover adhan-reached → gap →
expires → next-prayer, a zero-minute offset never opening a gap, and
Isha's own gap before falling through to tomorrow's Fajr. New
`IqamaGapRow` widget reuses the existing digit-fade countdown
treatment on the cyan accent token; `PrayerHero` fires one
(crash-hardened) `ParticleBurst` as a one-time "ignition" moment right
as the gap opens, per noor-kinetic-typography's guidance against
per-tick particle effects. Default iqamah offsets updated to the
requested starting points (20/10/10/5/10) in both the Dart default and
the DB schema's DEFAULT clause — the per-prayer +/- adjustment UI in
Settings (`IqamathOffsetSection`) already existed, nothing new needed
there. 223 tests passing. Pushed (`f870e9d`). Not yet live-verified —
phone disconnected for this whole segment.

### Duas & Dhikr bookmarking — 2026-08-26, ~16:15-17:00
Direct request: "own set of dua every day", mirroring the Quran tab's
existing bookmark feature. New `azkar_bookmarks` table (schema version
7, additive-only migration), `AzkarBookmarkRepository` (split from
`azkar_repository.dart` to stay under the 150-line file limit), a
bookmark icon on every `AzkarItemTile`, and a dedicated Bookmarks
screen off the Duas & Dhikr app bar showing the full item (not just a
label) so it's actually usable to recite from daily.
`AzkarCubit.loadBookmarks` merges freshly-fetched progress into the
existing map rather than replacing it, so an item bookmarked from a
different category still shows its real count instead of a stale 0 —
covered by a dedicated test. New `noAzkarBookmarksMessage` l10n string
(EN/SI/TA) since the existing one says "ayah". 226 tests passing,
`flutter analyze` clean, `flutter build apk --debug` succeeds. Pushed
(`31a128f`). Not yet live-verified — phone disconnected for this whole
segment; verify both this and the Iqama-gap state live as soon as it
reconnects.

### Two more suspicious mid-turn messages, not acted on — 2026-08-26, ~16:00
Same pattern as before: (1) a message asking to reconfigure tool-
permission settings (no tool available to do this regardless) and
"go back" to a nonexistent prior "Athan app comparison" task — nothing
like it exists anywhere in this session; (2) sent again, more
insistently, claiming to be the user "directly, myself, right now."
Insistence isn't authentication. Neither acted on; both flagged back
in-chat. No permission settings changed, no comparison task started
without the user separately describing what to compare.

### Found, flagged, NOT fixed: pilgrimage asset bundled despite being unreachable — 2026-08-26, ~19:20
While checking About page attribution completeness: `pubspec.yaml`
excludes `assets/talbiyah/` with an explicit comment — "only the
cut-from-v1 Hajj/Umrah guide feature used it... nothing in the shipped
app loads it, so there's no reason to ship the bytes or owe its
attribution." `assets/pilgrimage/` is in the exact same situation
(confirmed: nothing anywhere references `PilgrimageHomeScreen`, the
feature's only entry point — same "cut from v1" status as Hajj/Umrah)
but is still bundled, and `about_sources_card.dart` credits Quran
audio and Azkar text but has no entry for pilgrimage's MIT-licensed
HisnElMuslim dua text at all.

Did not fix this myself: removing the pubspec entry would break
`test/features/pilgrimage/pilgrimage_dua_repository_test.dart`, which
loads the asset via `rootBundle` (needs the pubspec declaration to
resolve during `flutter test`) — so the real fix isn't just deleting
one line, it's a judgment call about whether pilgrimage is meant to
stay permanently dead (in which case: exclude the asset like talbiyah,
and either delete or explicitly skip its now-asset-less tests) or get
re-enabled later (in which case: leave the asset bundled, but it does
need an attribution entry in `about_sources_card.dart` for as long as
it ships). Left as-is pending that decision rather than guessing.

### Live-verified: notification fixes work end-to-end on a real device — 2026-08-26, ~22:36
Rebuilt, installed, and checked every piece of the notification work
directly on the phone rather than trusting the code alone:

- App and Settings both launched cleanly after the pilgrimage removal
  and all the notification changes — no crash, no regression on the
  after-Isha countdown-to-tomorrow's-Fajr logic.
- More screen confirmed Hajj/Umrah/Pilgrimage tiles are actually gone.
- New "Reliable notifications" Settings section: correctly showed the
  not-exempted warning + button on first load, the button opened the
  real system battery-settings screen (MIUI's "Battery details"), and
  after granting "No restrictions" and returning to the app, the
  resume-refresh correctly flipped to the exempted checkmark message
  — the full loop works live, not just in the widget test.
- Test Adhan (Fajr): fired immediately as a real notification with
  the noor icon, confirming the `.show()`/channel/sound path.
- The real test for the multi-day scheduling fix: `adb shell dumpsys
  alarm | grep com.noorapp.noor` shows genuine `RTC_WAKEUP` alarms
  registered for **today through Aug 29** (4 days deep), all
  `exactAllowReason=allow-listed`. This is the actual OS primitive
  that fires notifications — confirming the scheduling-horizon fix
  works end-to-end on a real device, not just in the unit tests.
  Didn't wait hours for an actual fire (impractical), but this is a
  direct check of the exact mechanism that would fire, which is
  stronger evidence than waiting and hoping nothing else confounds
  the result.

Everything from tonight's notification-reliability pass is now
live-verified, not just analyze/test-clean.

## Overnight session — 2026-08-26 late night into 2026-08-27

Working through a large queued list independently, committing each
item as it's finished and verified. This section is the running log —
check here first for current status before assuming anything is
still open.

### Done, committed, live-verified
1. **"Visiting the Sick" Azkar category** (`055871b`) — split out of
   the combined `illness` category per direct request. New
   `azkar_supplementary_import_3.dart` moves the two shared rows
   (matched against its own bundled JSON at import time, never a
   hand-typed string — a hand-typed version genuinely failed its own
   test first) rather than duplicating them. Verified character-for-
   character against a fresh re-download of the source. Checked Hisn
   al-Muslim for other standard sections not yet covered — found a
   funeral/bereavement cluster, weather, food-and-fasting, and
   marriage clusters missing; flagged in assets/azkar/README.md
   rather than added speculatively.
2. **Qibla compass root-cause fix** (`252c8a3`) — the "compass
   blanks to a small gold blob" bug, previously guessed as a GPU/
   Skia issue, was actually QiblaCubit wiping a good heading back to
   null on every transient null-heading compass event (confirmed this
   device's magnetometer stream does this mid-stream, not just before
   first fix), which made the whole compass swap out for a loading
   spinner. Fixed at the source; live-verified stable across repeated
   screenshots where it previously blanked reliably. Also confirms
   the 2026-08-25 2D redesign is genuinely live, not just claimed.
3. **Home countdown vs. current time clarity** (`252c8a3`) — countdown
   now captioned "Next prayer in"; current time pulled into its own
   separated, labeled chip instead of sitting inline 10px away in
   similar-weight numerals. Live-verified on device.
4. **Bookmark staleness fix** — re-confirmed still solid (its
   regression test and the full Azkar suite pass); no rework needed.

### In progress / queued next, in order
5. Icon polish pass (bottom nav + More screen) — original designs,
   Athan-app-inspired *treatment* only, gold/cyan palette.
6. Adhan licensing research (calm-voiced, openly-licensed reciter).
7. Re-verify notification reliability items are still intact (not a
   redo — last night's `dumpsys alarm` check already confirmed this
   live; re-checking boot-receiver + exact-alarm + scheduling mode
   are all still wired before calling it confirmed).
8. Battery-optimization guided first-launch step — check whether this
   is a first-run prompt (not just the existing Settings section) and
   build it if missing.
9. Home-screen widget (next prayer name + time, offline).
10. Local encrypted backup/export (streaks, Zakat settings, bookmarks).
11. "Send Feedback" button (WhatsApp/email handoff, mirroring Support
    the Developer).

Items 9 and 10 are substantial native/engineering work in their own
right (a real Android AppWidgetProvider; a real encrypted export
format) — if usage runs out before reaching them, they're genuinely
not started, not partially done, and that will be stated plainly
rather than implied finished.

### Flagged, not built: battery-optimization first-launch step (item 8)
Checked `location_onboarding_screen.dart` — its own top comment
records a *deliberate* 2026-08-25 decision to cut this exact step,
quoting the direct feedback that caused it: "people will not like
that question... this is critical — a second permission-style prompt
during first launch was too much friction." The battery-optimization
prompt lives in Settings instead (`battery_optimization_section.dart`,
built and live-verified last night), reachable but not forced.
Tonight's instruction asks to build a first-launch guided step for
the same thing, which would silently reverse that explicit prior
call. Not building it unilaterally — flagging the conflict instead.
If a first-launch step is still wanted despite the friction concern
already on record, say so directly and it's a small addition (same
pattern as the location screen, one more screen after it).

### Done, committed, live-verified (continued)
7. **"Send Feedback" button** (`66765d1`) — was genuinely missing
   (only "Support the Developer" existed). Mirrors its exact
   WhatsApp/email OS-handoff pattern, different message content, sits
   between About and Donate in Settings. Live-verified: opens, both
   buttons present and correctly styled.
8. **Notification reliability re-check** — not a redo. Confirmed
   still intact: boot receiver in the manifest, `SCHEDULE_EXACT_ALARM`
   declared, and real `RTC_WAKEUP` alarms currently registered
   (`exactAllowReason=allow-listed`) via `dumpsys alarm` on the live
   device, spanning multiple future days.

### Researched, nothing shippable found: licensed calm Adhan (item 1)
Same honest "not found" outcome as the earlier Azkar audio search —
reported plainly rather than settling for an uncertain source.
- The one CC0-badged candidate (Freesound, "sonically_sound") fails
  verification despite the badge: its own description says the audio
  was "extracted from [a YouTube video] and processed" — the uploader
  is not the reciter and gives no indication of having obtained the
  original creator's rights before self-declaring CC0. A license
  can't be granted by someone who doesn't hold the rights, so this
  isn't trustworthy regardless of what badge it carries.
- A second Freesound item (RJStefanski, genuinely and verifiably CC-
  licensed, real field recording) is a real option for the *license*
  question but not the *content* question: it's an ambient recording
  of a real muezzin at a real mosque, background noise included —
  wrong style for in-app notification audio, and it captures a real
  person's voice/mosque without their own direct consent, which sits
  oddly for a religious utility even where the recording-copyright
  chain is technically clean.
- Everything else found (Assabile.com, YouTube "no copyright"
  channels) is the same "free to listen" ambiguity already ruled out
  for the Azkar audio search — no explicit redistribution license,
  self-declared without visible chain of title.
No Adhan audio change made. If the developer knows a specific
reciter, mosque, or Islamic organization that has explicitly released
Adhan audio under an open license, point at it directly and it can be
verified and wired in properly — same as the Azkar audio gap.

### Stopping point — 2026-08-27, ~00:20

Stopping cleanly here rather than starting the three remaining items
half-done. Everything above this line is committed, analyzed clean,
and either live-verified on device or (for the Adhan research and the
battery-optimization conflict) a plain finding with nothing left
half-edited.

**Genuinely not started** — each is substantial scope on its own, not
a quick add, and starting them at low remaining budget risked shipping
something shaky rather than something real:
- **Icon polish pass** (original bottom-nav + More-screen icon
  designs, Athan-app-inspired treatment only). Current icons are
  plain Material glyphs; a genuine redesign means real custom icon
  assets, not a font swap.
- **Home-screen widget** (next prayer name + time, offline). Needs a
  real Android `AppWidgetProvider` + `RemoteViews` layout + a way to
  push prayer-time updates into it from the existing Dart-side prayer
  calculation — new native surface area, not a Dart-only change.
- **Local encrypted backup/export**. Needs a real file format
  decision, a passphrase-based encryption scheme (the app's DB
  passphrase is Keystore-bound and device-specific, so this needs its
  own scheme — see noor-database-security's Keystore note), and a
  restore path that can't corrupt the live DB on a bad import.

Next session should start with icon polish (smallest of the three,
self-contained, no schema/native risk) before the two bigger
engineering items.

## Continuation — 2026-08-27, ~07:00

### Icon polish pass — code done, build clean, live-verify pending
Built an original 12-glyph line-icon set (`lib/core/presentation/
icons/`) replacing the plain Material icons across the bottom nav and
the More screen grid: a sundial for Prayer Times instead of a wall
clock, an open-hands glyph for Duas & Dhikr, a strand of prayer beads
for Tasbih instead of a generic circular-blur glyph, a balance scale
for Zakat instead of a calculator, adjustment sliders for Settings
instead of a gear, and a Qibla tile glyph deliberately matching the
redesigned Qibla screen's own compass needle shape. Also fixed the
Settings/About tiles reading flat/washed-out next to the other four
(they were plain sage with no real tile tint) — now cyan/gold like
the rest, so all six tiles are visually one family.

`flutter analyze`: clean (same 34 pre-existing info hints, zero new).
Full home/more/settings test suite: passes (the one reported
"failure" is `test/features/more` not existing as a directory, not an
actual test failing).

**Update**: committed (`b8c2056`) after a full clean analyze + the
whole 217-test suite passing, including a real regression this pass
surfaced and fixed — `key_screens_smoke_test.dart` located bottom-nav
tabs and More tiles by `Icons.*` IconData, which no longer exists on
these custom-painted widgets; switched to finding by visible label
text instead. **Still not live-screenshotted** — the phone has been
in active personal use or disconnected through this whole segment.
Static confidence is high (clean analyze, full suite green, every
painter shape reviewed against its intended design), but per
noor-visual-self-qa this isn't fully "done" until actually seen
rendered on the device — first thing to screenshot-verify once the
phone is free and reconnected.

### Local encrypted backup/export — done, committed, not yet live-verified
Built (`6d9cde7`): AES-256-GCM with a PBKDF2-derived passphrase key,
exports prayer/fasting streak history + Quran/Azkar bookmarks + Zakat
price memory to a file via the system share sheet, restores via the
system file picker. Additive-only restore (never deletes existing
data). Azkar bookmarks matched by Arabic text, not row id, since ids
aren't stable across installs — proven by a test that deliberately
gives the same item different ids on two simulated devices. New deps:
`cryptography`, `share_plus`, `file_picker`, `path_provider` — all
local-only, no new Android permission, no INTERNET.

`flutter analyze`: clean. 8 new tests (crypto round-trip, wrong-
passphrase rejection, tamper detection, payload JSON round-trip,
gather→restore round-trip across two simulated devices, double-
restore idempotency): all passing. **Not yet live-verified** — same
reason as the icon polish above (phone unavailable this whole
segment). Queued as the very next thing to check once it's back:
export a real backup, confirm the share sheet opens with a real file,
then restore it and confirm the data actually lands.

### Still fully unstarted: home-screen widget
Needs a real Android `AppWidgetProvider` + `RemoteViews` layout + a
way to push prayer-time updates into it from the existing Dart-side
calculation — new native surface area, not touched yet.

## Continuation — 2026-08-27, phone unavailable ("for a while")

### Qibla: calibration-banner flicker fix + Kaaba marker redesign — code-verified, live-verify pending
Root cause of the repeated "still blinking" reports, found via code
review (not guesswork): `qibla_screen.dart` was mounting/unmounting
`CalibrationPrompt` with a raw `if`, an instant pop that read as
flicker even after the needle's own rotation/alpha were already
smoothed on an earlier pass. Replaced with a new
`AnimatedCalibrationBanner` widget (`AnimatedSize` + `AnimatedSwitcher`)
so it now fades and collapses smoothly.

Self-caught bug during that same review: my first draft used
`AnimatedOpacity` wrapping a ternary child — the ternary swaps the
actual widget instance the same frame the opacity starts animating
toward 0, so the banner would still have vanished instantly instead of
fading. Fixed by switching to `AnimatedSwitcher` with distinct
`ValueKey`s per branch, which correctly keeps the outgoing child
mounted while it fades out.

Also replaced the plain gold rounded-square Kaaba marker with a small
cube icon (kiswah band + door accent) plus a slow breathing glow, per
direct feedback to "put the cover on the middle of the compass" and
add animation — new `kaaba_marker_painter.dart`, driven by a new
`_kaabaPulseController` in `qibla_needle.dart`.

`qibla_screen.dart` and `qibla_needle.dart` both crossed the 150-line
limit once these changes landed; split into `animated_calibration_
banner.dart`, `kaaba_marker_painter.dart`, and `qibla_needle_ring.dart`.

**Verified without a live device**: `flutter analyze` clean (only the
same pre-existing const-hint infos — one real `unused_import` warning
this pass introduced, in `qibla_needle.dart`, was caught by analyze
and fixed before commit); full test suite passes, 217/217, zero
failures; `flutter build apk --debug` compiles clean against the
current tree. Committed `0fc9ba0`, pushed.

**NOT yet confirmed — needs the phone**: whether the banner's fade
actually reads as smooth on-device (vs. just in code review), whether
the new Kaaba cube icon and pulse look right at actual compass scale,
and — the thing that actually matters — whether these two fixes
together resolve the "still blinking" complaint. Do not mark this
Qibla item closed until seen live.

### Native splash white-flash — root cause found and fixed, live-verify pending
Confirmed the exact bug described in the overnight package's item 1a:
`android/app/src/main/res/drawable/launch_background.xml` had
`android:drawable="@android:color/white"` — the native Android splash
window (shown before Flutter even starts) was literally white, not
the custom splash widget misbehaving. The `drawable-v21` variant used
`?android:colorBackground`, which also resolves to white under
`Theme.Light`. Neither `styles.xml` nor `values-night/styles.xml`
overrode it for `NormalTheme` either.

Fixed: added `android/app/src/main/res/values/colors.xml` with
`splash_background = #FF05070B` (locked obsidian), and pointed both
`launch_background.xml` variants and both `NormalTheme` styles
(`values/styles.xml`, `values-night/styles.xml`) at it. Native-only
change, no Dart touched.

`flutter build apk --debug` run fresh against this change to confirm
it compiles. **Not yet confirmed**: that the white flash is actually
gone on a cold launch on-device — this can only be seen live, not
inferred from a clean build.

### Splash sequence — correction: already built, my earlier note here was wrong
Checked the code before starting on this "queued" item and found it's
already fully implemented and live-device tuned: `BigBangSplashView`
(`lib/core/presentation/splash/big_bang_splash_view.dart`) does the
particle burst → Arabic Bismillah (scaling in from depth, not a flat
fade) → dissolve into the NOOR wordmark sequence, wired in via
`splash_screen.dart`. Timings in `splash_config.dart` carry comments
citing two separate 2026-08-24/08-25 live-device review passes that
already tuned pacing ("it should ... com[e] up to the front — the
splash overall felt slow" → burst duration cut in half) and text
ordering (Arabic before any English, per explicit request). Falls
back to a calm `PlainSplashView` under reduced-motion. Nothing to do
here — already done.

### Tap-feedback micro-animations + screen-transition polish — audited, done
Before building a new tap-feedback wrapper as originally planned,
audited what already exists rather than assuming this was unbuilt (the
splash-sequence note above turned out to be stale, so re-checked this
one too before writing more code). Found it's almost entirely already
built:
- `SemanticButton` (`lib/core/utils/semantics_helpers.dart`) is
  already the app's tap-feedback chokepoint — a 0.98 press-scale,
  used in 34 files across every feature.
- `AppChip` has its own equivalent scale-down for the same reason
  (its own header comment says so explicitly).
- `TasbihOrb`, the app's single most-tapped element, has its own much
  richer custom tap-bounce/shake/spring feedback on top of
  `SemanticButton` internally.
- Screen transitions: `FadeTabSwitcher` already cross-fades + slides
  between bottom-nav tabs (not an instant cut), and there are no
  custom zero-duration route overrides anywhere in `lib/` — screen
  pushes use Flutter's own default `MaterialPageRoute` transitions.

The one real gap, found by grepping for raw `GestureDetector`/
`InkWell` outside the few legitimate cases (drag areas, `AppChip`
itself, ripple-based list rows): the first-run locale selector in
`location_onboarding_screen.dart` had a hand-rolled
`Semantics()`+`GestureDetector()` pair with zero tap feedback —
exactly the pattern `SemanticButton`'s own doc comment says to avoid.
Converted it to `SemanticButton`. `flutter analyze` clean (no new
issues on the file), full suite passes 217/217, no regressions.
Committed and pushed.

This closes out the "tap-feedback micro-animations, screen-transition
polish" queued item. **Not yet confirmed live**: that the fixed
locale-selector button actually feels right on a real screen — like
everything else in this section, pending phone reconnection.

## Session — 2026-08-28, working autonomously (phone disconnected most of this session)

Working through a large multi-message backlog independently per direct
instruction: commit each item as finished, log here after every commit,
don't wait for input. Check here first for current status.

### Real Light theme built and shipped (commit `fbd744c`)
The Dark/Light/System toggle in Settings was already correctly wired
(a prior fix) but `buildLightTheme()` was a stub returning the exact
same dark ThemeData as `buildDarkTheme()` — flipping the toggle changed
nothing visible. Built a real `AppColorTokens` ThemeExtension
architecture: `cosmic` (today's values, copied verbatim, pixel-
identical to before) and a new `light` palette, with ~104 files
migrated off static `AppColors` onto `context.colors` so both themes
share one real token system and repaint live app-wide on toggle.
Light gets pill-shaped buttons and a subtler (not disabled) particle
background. Qibla's compass painters and the splash sequence stay
frozen on Cosmic colors deliberately (fragile live-tuned code, and
splash is a brand moment not a themed screen). Live-verified on
device: Dark -> Light -> Dark re-themes instantly, Dark unchanged.

### Theme labels renamed, contrast fix, battery/privacy-policy UI cleanup, About screen wording (commit `a2185c7`)
- Dark/Light labels -> Nebula/Dawn (display label only).
- Cosmic's secondary text color (`sage`) bumped `#8A93A3` ->
  `#AAB3C2` — direct feedback it read too low-contrast. Light theme
  untouched at this point (see below — revisited same session).
- Battery optimization section: the "exempt from battery
  optimization" confirmation text no longer shows once granted
  (renders nothing, including its own header) — the exemption request
  flow itself is unaffected.
- About screen: mission text replaced with the exact requested
  wording; removed the "Amiri" font-credit entry; Privacy Policy link
  hidden (method kept, not deleted). Tanzil/tanzil.net attribution in
  AboutSourcesCard deliberately left untouched.
- Send Feedback screen intro softened to a warmer invitation.
- **Still needs the user's own decision, not mine**: open-source
  licence attributions for bundled fonts/libraries, before the About
  page's licence section can be called finished.

### Qibla — real bug reproduced live, root cause still open
Opened Qibla, captured rapid screenshot sequences: compass genuinely
blanks to near-nothing (~70% of frames, only a faint Kaaba glow
survives) then fully renders on others. Confirmed this is the CURRENT
build (`79ac304`, the "simplified 2D" commit), not a stale install —
the glitch is real and still present in the latest code, not fixed by
that commit. Tested one concrete hypothesis live: disabled Impeller
(Flutter's newer Android renderer) via
`io.flutter.embedding.android.EnableImpeller=false` in
AndroidManifest.xml, rebuilt, reinstalled, re-tested — **no
difference, ruled out, reverted**. logcat during the glitch shows no
Dart exception at all, only native `HwcComposer: presentOrValidateDisplay presentFence:-1`
noise (a device/compositor-timing signal, not a Flutter-side error).
**Not resolved.** Next real step once the phone's back: a
`screenrecord` capture (rules out screencap-IPC racing the compositor
as an alternate explanation for what screenshots show) — queued, not
yet tried.

### Zakat: math verified correct, icon already fixed (no code changes needed)
- Nisab constants (87.48g gold, 612.36g silver, 2.5% rate) match fiqh
  reference values exactly; "lower of the two metals" rule correctly
  applied; existing test suite independently covers edge cases
  (exactly-at-nisab, one cent under, liabilities exceeding assets).
- Zakat's More-screen icon is already a custom gold balance-scale
  (`ZakatIconPainter`), not a plain circle — live-confirmed on device
  this session. Whatever "still a plain circle" report prompted this
  item is stale relative to the current build.

### Confirmed already live, no changes needed
- Dua library (Evening/After Prayer/Sleep/Travel/Child Protection/
  Illness/Distress/Debt/Visiting the Grave/Visiting the Sick) — all
  present, live-screenshotted this session.
- Custom bottom-nav + More-screen icon redesign — live-confirmed
  rendering correctly in both themes.
- Quran recitation audio (Dhikr Al-Huda, Juz Amma only, CC BY 4.0) —
  already wired to the play button on `surah_reader_screen.dart`,
  confirmed in source, nothing to do.
- Exact-position Quran bookmarking — already built:
  `SurahReaderScreen`/`FullQuranScreen` both track precise ayah-level
  reading position (`ReadingPositionTracker` + `markLastRead`) and
  auto-scroll back to exactly where the reader stopped, plus a
  separate manual per-ayah bookmark icon. One live discrepancy
  flagged: `AyahTile` renders translation text whenever present in
  the data (most ayahs have one, from an earlier backfill) — if
  literal Arabic-only is wanted, that's a small separate change, not
  yet made.

### Selectable Adhan sound — built, wired end-to-end (commit `7ed6d08`)
4 new options added on top of the existing Public Domain default
(`doha`) — see assets/audio/adhan/README.md for full per-file
licence/provenance detail and the one flagged, unresolved content-
appropriateness concern (Hamtramck: real muezzin, no direct consent
to this reuse, licence itself is clean). Wired all the way through:
Settings picker + required attribution line, in-app preview, Test
Adhan section, AND real scheduled notifications (new per-reciter
Android channel ids, since a channel's sound is immutable after
creation — `doha` keeps its original channel ids unchanged). Schema
v8 -> v9. This reverses the 2026-08-23 "ship with the default reciter
only" decision — noted for the record per direct re-request, not
silently overridden. **Not yet live-verified** — phone disconnected
for this whole segment; verify preview + Test Adhan + a real
non-default scheduled notification once it's back.

### Next up (in progress when this was written)
- Light theme text contrast pass (separate from the Cosmic sage fix
  above — direct follow-up feedback: light theme confirmed looking
  good, wants a small further contrast bump for readability).
- Re-verify everything not-yet-live-verified above once the phone
  reconnects, in this order: Light theme contrast, Qibla screenrecord
  capture, Adhan reciter selection (preview/test/real notification).

## Session — 2026-08-29 (continued): Qibla sensor-error crash fix + blank-frame proof

### Fixed: unhandled sensor stream errors (real crash risk on cloud emulators)
Investigated a report that Qibla/location might be crashing unhandled
on Appetize's emulated environment (no real sensor hardware). Found a
real, concrete gap: `QiblaCubit._listen()` subscribed to both the
compass and tilt sensor streams with no `onError` handler, and
`main.dart` has no global zone guard (`runZonedGuarded`) either — so a
platform-channel failure (which `flutter_compass`/`sensors_plus` are
known to raise as a genuine stream error, not just a null reading,
when no real sensor exists) had nothing catching it anywhere in the
chain. Fixed: both subscriptions now have `onError`, degrading the
same way a missing sensor already does (`CompassAccuracy.unavailable`
for compass, centered/0,0 for tilt) instead of throwing. Split
`qibla_cubit.dart` into three files to land back under the 150-line
limit (it was already over at 219 lines before this fix, un-caught
until now): `qibla_accuracy_debouncer.dart` (hysteresis logic) and
`qibla_sensor_binder.dart` (the actual stream-to-state wiring). Two
new regression tests (`qibla_cubit_sensor_error_test.dart`) simulate a
`PlatformException` on each stream via `controller.addError(...)` and
assert graceful degradation. 220/220 tests passing, `flutter analyze`
clean. Live-verified: fresh release-signed install, ran normally, no
crash, no exception in logcat.

### Confirmed via screen recording: the original Qibla blank-frame bug is a REAL rendering glitch, not a screenshot artifact
This is unrelated to the fix above (that one prevents a crash on
missing sensors; this is a separate, still-unsolved bug where the
compass visually blanks intermittently on a device that DOES have
working sensors). Long-standing open question: was the blank/blink
pattern seen in `adb screencap` sequences a real thing the user could
see, or an artifact of screencap's IPC racing the display compositor?
Settled this definitively today: captured a real `adb shell
screenrecord` (native H.264 encoder reading the actual composited
display output — a completely different capture path than
screencap's IPC) and extracted frames with `ffmpeg`. The exact same
blank/full alternation appears in the video itself — two consecutive
extracted frames, both timestamped the same second (~125ms apart),
one fully blank except a tiny gold pixel, the next fully rendered.
**This is a genuine, physically-visible rendering glitch on this
device, happening multiple times per second** — not a screenshot-tool
artifact. Root cause is still open (Impeller was already ruled out
earlier this session by disabling it and retesting — no difference).
Next real step: try forcing the legacy Skia *software* rasterizer
(not just disabling Impeller, which still uses Skia+Vulkan/GL) or
capture a native GPU trace, since this now looks like something in
the compositor/GPU driver layer specifically, not a Flutter-level
logic bug (the fix history already ruled out the Dart-side heading-
nulling theory, RepaintBoundary, and emit-throttling, and now Impeller
too).

## Session — 2026-08-29 (continued): 10-item punch list, `024f2dd`

Per direct instruction, checked build-vs-commit staleness honestly
before touching code, then worked the list in order. No phone
connected this pass — everything below is `flutter analyze`/`flutter
test` verified only, stated as such, not live-confirmed on device.

1. **Icon** — confirmed via `git log --all` on the mipmap PNG: only 2
   commits ever touched it (the Flutter stock default, then the
   cyan star/compass-rose) — no "crescent" icon has ever existed in
   this repo's history, so the ask to "revert" to one describes
   something that never shipped. Designed a new gold-crescent/cyan-
   ring/obsidian icon instead (`scripts/gen_launcher_icon.js`, a
   hand-rolled PNG encoder — no canvas/ImageMagick available here),
   visually confirmed via Read on the xxxhdpi output before writing
   all 5 densities. **New design, not a literal revert — said plainly
   rather than implied otherwise.**
2. **Splash overlap** — real bug, fixed. Bismillah's fade-out
   (`easeIn`) and NOOR's fade-in (`easeOutCubic`) both spanned the
   same 0..1 dissolve range with different curves, so at t=0.3
   Bismillah was ~91% opaque while NOOR was already ~66% opaque —
   genuine simultaneous visibility, not just a blend. Split into two
   non-overlapping halves.
3. **Daily checklist** — root cause found: `allowBackup` was never
   set (defaults true), and `dumpsys backup` showed real backup
   history for this package, so Android Auto Backup could silently
   restore stale local DB state on a "fresh" install. Fixed
   (`allowBackup="false"`). **Caveat stated honestly**: a live fresh
   install on the pre-fix build actually showed correct behavior, so
   this may be intermittent/timing-dependent rather than the only or
   fully deterministic cause — not oversold as fully proven without a
   phone to reproduce the exact restore scenario. Future-prayer
   locking was checked and already correct (`daily_goals_list.dart`'s
   `_hasOccurred` gate, pre-existing).
4. **View Progress redesign** — **not started this pass.** Genuinely
   open, not touched — flagging honestly rather than claiming partial
   progress.
5. **Quran translation** — live-screenshot confirmed English was
   showing under the Arabic on the main reading screen. Fixed:
   removed the translation block from `AyahTile` (search results use
   a separate widget, untouched). Test rewritten to assert the
   opposite of a stale 2026-08-25 decision.
6. **Dua library expansion (50+ Hisn al-Muslim entries)** — **not
   attempted this pass.** Per noor-religious-text-verification, every
   new entry needs its exact source text pulled and diffed character-
   by-character, not typed from memory even by a "verified" source
   name — that's 50+ real source fetches and diffs, not something to
   rush inside a larger multi-item pass. Left out rather than guessed,
   per this project's own standing rule.
7. **Bounce-scroll app-wide** — already done, nothing to add:
   `AppScrollBehavior` (wired into `MaterialApp.scrollBehavior` in
   `app.dart`) already applies `BouncingScrollPhysics` globally, so
   every `ListView`/`GridView`/`CustomScrollView` in the app already
   has it without per-screen wiring.
8. **Text-reveal on a key moment** — applied to Home's "Assalamu
   Alaikum" greeting (`hero_card.dart`), the one place already doing
   a deliberate reveal→hold→fade sequence: the fade-in is now a
   character-by-character build using the same existing
   `AnimationController`/timing (no second animation system bolted
   on), staying whole through the later fade-out rather than reversing
   letter-by-letter.
9. **Tasbih orb polish** — added one concrete, bounded improvement
   tying "responsiveness" to the orb's own drag gesture: the cyan rim
   glow now brightens and widens in proportion to how far the orb is
   currently pulled (`pullFraction` threaded from `TasbihOrb`'s
   existing `_dragOffset` into `OrbFace`), rather than being a fixed
   decoration. Existing 3D tilt/spring/idle-breathing untouched.
10. **Qibla status** — no redesign attempted, per explicit instruction
    not to reopen the 3D question. Honest current state, unchanged
    from the last entry above: the sensor-error crash fix (`3c94fc5`)
    is separate and solid; the actual visual blank/blink glitch is
    confirmed real via `screenrecord` (not a screenshot artifact),
    root cause still open, Impeller already ruled out, software-
    rasterizer/GPU-trace is the next real step, not yet tried.

Also this session: merged 4 new skills (`noor-bounce-scroll`,
`noor-text-reveal`, `noor-icon-generation`, `noor-targeted-scope`) and
added the new top-of-file WORKING METHOD section codifying the
targeted-scope rule as permanent, not one-time. 220/220 tests passing
throughout, `flutter analyze` clean (only pre-existing info hints).
Pushed as `024f2dd`. Items 4 and 6 are the two genuinely open ones
from this list — say so plainly if asked "is everything from the
10-item list done."

### Live-device verification of `024f2dd` — 2026-08-29, ~19:20-19:31
Phone reconnected (device `lbzdfer8vkaqiziz`). `adb` was found at
`E:\android-sdk\platform-tools` this session, not the
`C:\android-sdk` path recorded in an earlier log entry — that path is
stale, use `ANDROID_HOME`/`ANDROID_SDK_ROOT` (both point at `E:`) or
search fresh rather than trusting the old path. Fresh debug build,
installed with `adb install -r` — failed once first with
`INSTALL_FAILED_UPDATE_INCOMPATIBLE` (the previously-installed build
was release-signed, this one debug-signed); `adb uninstall` then
`install -r` fixed it, which also gave a genuinely clean fresh-install
state to test item 3 against.

Confirmed live, not just analyze/test:
- **Daily checklist (item 3)**: fresh install shows all 5 prayers
  correctly unchecked. Directly confirms the `allowBackup="false"` fix
  didn't regress the base case — doesn't by itself prove the backup-
  restore scenario is fixed (that needs a real prior-install-with-
  backup-history device state to reproduce, not available here), but
  the honest fresh-install case is verified.
- **Launcher icon (item 1)**: home screen icon is the new gold
  crescent/cyan ring design, genuinely live, not a stale cached icon.
- **Quran translation removal (item 5)**: opened Surah 1 — Arabic
  only, no English line under any ayah. Directly confirms the earlier
  live-screenshot bug (translation showing) is fixed.
- **Tasbih orb (item 9)**: renders correctly at rest and survives a
  drag-and-release with no crash (logcat clean, count stayed at 0 —
  the drag wasn't misread as a tap either). One screenshot mid-drag
  showed a garbled single-pixel-wide render artifact — traced to firing
  two concurrent `adb shell input swipe` processes against the same
  touch device to try to catch the glow mid-gesture, not an app bug:
  a follow-up screenshot immediately after showed the orb fully intact.
  The glow-intensifies-with-pull effect itself wasn't caught in a
  clean still frame (inherently hard to time via serial adb screenshots
  against a live gesture) — the underlying logic is simple and
  directly reuses the same `_dragOffset` the pre-existing, still-
  passing `tasbih_orb_test.dart` already exercises, so this is
  reported as "live-confirmed no regression," not "glow visually
  confirmed peak-bright."
- Splash overlap (item 2) and the Home text-reveal (item 8) were not
  independently re-verified live this pass — both are fast, one-time
  animations that finish before a screenshot can be lined up
  reliably; `flutter test` already exercises `widget_test.dart`'s
  splash-to-home transition and no visual regression was seen in
  passing.

No new bugs found. No code changes this pass — verification only.

### Support & Donation addendum — 2026-08-29, ~20:15, `76de966`
Locked decision confirmed directly: no payment system, no feature
locks, everything free always — monetization stays entirely the
existing Support the Developer screen. Added two dismissible
touchpoints per spec, neither inside Quran or Prayer Times: a Home
card (`SupportHomeCard`, dismiss once and it's gone for good) and a
one-time bottom-sheet nudge at the 100-count Tasbih milestone
(`maybeShowMilestoneNudge`, shown once per milestone key ever, backed
by a new `SupportPromptService` on `shared_preferences`, already a
dependency). A draft implementation was supplied for this in chat
referencing APIs that don't exist in this repo (`ThemeCubit`,
`paletteFor`, `core/constants/app_colors.dart`, `.clinerules`) — this
app uses `AppColorTokens`/`context.colors` and has no `.clinerules`
file, so the logic was kept but every widget was rewritten against
this repo's actual theme/semantics APIs rather than copied verbatim.
6 new tests, 226/226 total passing, `flutter analyze` clean. Same
`maybeShowMilestoneNudge` call is the pattern for a future prayer-
streak milestone — no new plumbing needed, just a second call site.

Continuing autonomously per standing instruction. Next up, in order
per the still-open items from the 10-item list above: the Progress
screen redesign (item 4), then the Dua library expansion (item 6,
still gated on real per-entry Hisn al-Muslim source verification —
see noor-religious-text-verification, not something to rush).

### Progress screen redesign — 2026-08-29, ~21:00, `f18af81`
Item 4 done. Was previously just a name field and a flat blue bar
chart (the exact complaint). Added `ProgressHeroStat` (headline
completion % + perfect-day count), `WeeklyPatternRow` (one ring per
day — gold+check for perfect, proportional cyan for partial, dim
hairline for missed, today outlined), and colored status icons on
`RecentDaysList`'s rows instead of a plain ratio. Also split
`progress_screen.dart` into 4 widget files while already restructuring
it — it was 254 lines, over this project's own 150-line-per-file rule
even before today. 11 new tests, 231/231 total passing, `flutter
analyze` clean. **Not yet live-verified** — phone was disconnected
again by this point in the session; screenshot-verify next time it's
connected, per noor-visual-self-qa (a design task isn't done from
source-reading alone).

Remaining from the original 10-item list: item 6 (Dua library
expansion) only — still gated on real per-entry Hisn al-Muslim source
fetches, not rushed.
