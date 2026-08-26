# noor — Claude Code Project Directive

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
  Existing code for this feature stays in the repo but is out of
  scope for this loop; revisit only when explicitly told to.
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
- [ ] Every Arabic string (Quran ayat, Azkar, dua text) checked against
      its Tanzil Project / Hisn al-Muslim source — verbatim, no
      re-typing from memory, shadda/diacritic errors specifically
      checked for (see 04_ISLAMIC_ENGINE notes on prior shadda defect)
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
- [ ] Privacy policy page/link added (required even for a no-network app)
- [ ] Confirm manifest has no INTERNET permission and no billing
      dependency anywhere in the dependency tree

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

**From this point in the session, the phone is disconnected.** Every
fix below is verified via `flutter analyze` + `flutter test` only,
explicitly noted as such — not live-tested on real hardware. Continue
per the user's standing instruction: work independently, keep this
log current, don't wait for input unless something is genuinely
broken and blocking.
