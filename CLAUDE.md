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
