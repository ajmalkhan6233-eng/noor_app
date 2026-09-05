# noor — Claude Code Project Directive

Full day-by-day session diary (everything before 2026-09-05) has moved
to [CLAUDE_HISTORY.md](CLAUDE_HISTORY.md) — nothing was deleted, just
moved out of this file so it stays quick to read. This file is the
one source of truth for current rules and current state.

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

## Standing Rules — Efficiency & Reporting (added 2026-09-05)

### Why This Work Gets Done This Way
Time is an amanah — a trust. The order of what deserves it doesn't
change just because a deadline is close: Allah first, then family,
then friends, then everything else — including whatever app or
business is being built right now. Every hour spent chasing an
unnecessary complication is an hour taken from that order. So
"efficient" here doesn't mean impressive or clever — it means
whichever path actually finishes the task and gives the time back,
because that saved time is what goes to the things placed first. This
applies to every project, every time, without exception.

### Rule 1 — Always Take the Simplest Working Path
Before starting anything new: what is the simplest, most standard,
most proven way to do this — not the most impressive, not the most
interesting?
1. Default to the plain, ordinary, known-working path first, even when
   a cleverer option seems tempting. Clever costs time; ordinary
   finishes.
2. Time-box any exploration of a faster approach — a small, fixed
   number of genuine attempts, then fall back immediately to the
   proven method. A slower method that finishes beats a faster one
   still being debugged.
3. The moment something is a dead end, say so plainly and move on.
   Don't chase it further out of momentum or pride in the attempt.
4. Efficiency never means skipping verification. Never claim something
   works without real on-device or real-world proof — a fast wrong
   answer costs more time later than a slower right one now.
5. When a request is genuinely unclear, ask one direct question rather
   than guessing. A wrong guess, built out fully, costs far more time
   than ten seconds of asking.

### Rule 2 — Report in Summary Only
When reporting back on any task: give the result, not the journey.
- State plainly whether it's done, blocked, or needs a decision.
- If something is needed from the person (a toggle to flip, a name, a
  choice), say exactly what and nothing more.
- Do not narrate the steps taken, the commands run, or the process
  followed to get there, unless something in that process is itself
  the thing blocking completion.
- One or two lines is the target for a finished task. Save detail only
  for genuine blockers or decisions that require it.

## Standing Rules — Scope, Verification, Content & Delivery (added 2026-09-03)

These apply to every future session, not just the current queue file.
If a task file's instructions ever conflict with these, these win.

**Scope discipline**
- Work through a given task file one task at a time, in the order
  listed. Don't jump ahead or batch multiple tasks into one commit.
- When a task points at a specific file/block, edit only that
  file/block. Don't regenerate, rewrite, or "clean up" unrelated code.
- If a task's file has a "BLOCKED" section, don't touch those items
  under any circumstance until explicitly told they're unblocked.

**Verification, not self-report**
- `flutter analyze` / `flutter test` passing is necessary but not
  sufficient. Before calling any UI-facing task "done," it needs to
  actually be checked on-device or emulator — not just confirmed by
  reading the source you just wrote.
- If on-device verification genuinely isn't possible in the current
  environment, say that plainly instead of implying it was checked.

**Content integrity**
- Never generate, paraphrase, or approximate Quranic text, Arabic
  duas, or Tamil/Sinhala religious text. All religious text comes from
  Tanzil Project (Quran) or Hisn al-Muslim (Azkar/Dua) — nowhere else,
  never invented.
- Never bundle or link to audio/text/images without a confirmed,
  stated reusable license. If a source's licensing isn't clearly
  stated, treat it as unusable and say so rather than proceeding.

**Architecture**
- Offline by default — see the one documented exception in
  Non-Negotiable Architecture below. Any *other* remote network call
  is a bug, not a feature — flag it. Zero analytics/ads SDKs, ever.
- Cosmic palette only, via `AppColorTokens` — never a competing token
  file.
- Every interactive widget needs an explicit `Semantics()` tag.
- Every reward/confirmation moment pairs its visual feedback with
  `HapticService().tap()`/`.milestonePulse()` — reuse the existing
  service, don't create a new one.

**Delivery**
- Push to a feature branch / open a PR rather than committing straight
  to `main`.
- When a batch of tasks finishes, summarize what actually changed
  (files touched, what each change does) rather than a bare "done."

## Current Status (2026-09-05)

### Confirmed working
- Splash sequence, Nebula/Dawn theme toggle (**both themes are real
  and live-verified** — Dawn/light is not a stub, don't rebuild it),
  bottom-nav + More-screen icons (redesigned 2026-09-05 as glossy 3D
  orb badges — gradient shading, cast shadow, gloss highlight; see
  [PR #9](https://github.com/ajmalkhan6233-eng/noor_app/pull/9))
- Prayer times, per-prayer alarm toggles, Silent Mode (DND-gated
  correctly), iqama-gap Home hero state
- Quran: Tanzil 1.0.2 text, page-turn reader (per-surah and full
  Quran), exact-position bookmarks, Ayah of the Day, optional
  downloadable audio for 4 curated surahs + bundled Juz Amma
- Azkar: 74 items across 11 categories (the real count — not the
  ~150 once assumed), bookmarking, hadith citations shown in the UI
- Adhan: 5 selectable reciters with per-reciter notification channels
- Calendar: Sri Lankan holidays (partial dataset) + user-created
  reminders wired to real notifications
- Tasbih: tap-only haptic counter (redesigned from a drag orb)
- Progress screen: hero stat + weekly ring pattern
- Locked monetization model intact: no IAP, no ads, no INTERNET beyond
  the one Quran-audio-download exception
- Encrypted DB (sqflite_sqlcipher), Keystore-backed passphrase, schema
  v10, migrations tested; adaptive launcher icon shipped

### Genuinely open
- **Qibla**: the real screen has a still-unsolved intermittent
  GPU/compositor rendering glitch (confirmed via screen-recording and
  pixel-diffed multi-frame bursts across many fix attempts — none
  resolved it). Routed to a "coming soon" placeholder tile for this
  release; the real screen and code are untouched, ready to re-enable
  once fixed. Next real step: an actual GPU/compositor trace, not
  another paint-code guess — see CLAUDE_HISTORY.md for everything
  already ruled out.
- **Adhan reciter variety**: candidates beyond the current 5 exist but
  every one found so far is an unedited field recording with no
  confirmed reciter consent — needs a specific, clearly-licensed name
  before adding another.
- **CI release signing**: the AAB workflow signs from 4 GitHub repo
  secrets, but `RELEASE_KEYSTORE_BASE64` is currently invalid (fails
  at the base64-decode step). Fix is Ajmal's own action — re-copy the
  value correctly in GitHub Settings → Secrets (exact steps in
  CLAUDE_HISTORY.md) — not fixable from the repo.
- **Daily-checklist occasionally pre-checked** on a fresh install —
  narrowed to reinstall-specific (not reproducible via `pm clear`),
  most likely an OEM (MIUI) backup path restoring the old DB alongside
  its Keystore passphrase — outside what `allowBackup=false` prevents.
- Azkar/Dua library still short of a fuller set (74 vs. a desired
  ~150) — each new entry needs a real Hisn al-Muslim source fetch and
  diff, not rushed.
- Full-Quran translation-language question conflicts with the already-
  shipped Arabic-only decision on the reading screens — needs a direct
  decision before either screen changes again.
- Windows desktop builds are currently blocked in worktree checkouts
  by Windows' 260-character path limit — a dev-environment issue, not
  an app bug.

## Stack
Flutter (Dart), native Android. NOT web, NOT React, NOT Three.js/WebGL.
State: flutter_bloc / Cubit. DB: sqflite_sqlcipher. Prayer math: adhan.

## Non-Negotiable Architecture
1. Offline-first by default, with exactly one deliberate, scoped
   exception: optional, user-initiated Quran audio downloads
   (`surah_audio_download_service.dart`). Every other feature has zero
   remote network calls, always. `INTERNET`/`ACCESS_NETWORK_STATE` are
   declared in AndroidManifest.xml solely for that one feature, with a
   comment saying so. Zero ad SDKs, zero analytics, ever. Any *other*
   new network-touching feature is a separate decision to make
   explicitly and knowingly, not something to slide in by extension.
2. No Play Billing / IAP library, ever. Monetization is handled
   entirely at the Play Store listing level — see Monetization
   Timeline below. Nothing billing-related lives in code.
3. Feature-first structure: `lib/features/<feature>/{data,logic,presentation}`
4. `lib/core/` holds only cross-feature singletons: constants,
   database, haptics, location, utils.
5. No Dart file exceeds 150 lines. Split before you hit the limit.
6. UI widgets never call the database or calculation logic directly —
   only through a Cubit/Bloc, which calls a repository.
7. Every interactive widget carries an explicit `Semantics()` with
   label, value (where relevant), and hint.

Note: the Qibla *screen* is temporarily unreachable from the More
screen (routed to a "coming soon" placeholder) — the architecture
above still applies to its untouched source, it's just not wired into
navigation for this release. See Current Status above.

## Visual Direction (Cosmic Expansion — reinterpreted for Flutter)
Locked tokens. Do not use Emerald / #0A1912 / #D4AF37 — retired:
- Obsidian background: #05070B
- Card surface: #0D1117
- Gold accent: #FFB703
- Cyan accent: #00F2FE

Glass panels: BackdropFilter(blur ~16) + 1px border at ~20% opacity
cyan. Particle/glow/shockwave effects: CustomPainter or Rive — never
Three.js/WebGL, that stack does not exist in this app. Motion:
implicit animations (AnimatedContainer, flutter_animate), not Framer
Motion.

**Both Nebula (dark) and Dawn (light) themes are real, built, and
live-verified** via `AppColorTokens`/`context.colors` — a future
session should never assume the light theme needs building from
scratch; if it looks unstyled somewhere, that's a specific widget
still on a legacy static color, not a missing theme.

## Deferred — Not Now (tracked, not scope for this loop)
- Masjid/community directory + chat: a separate app entirely (own
  backend, privacy policy, moderation plan). Not built inside noor.
- Additional monetization beyond the locked model (one-time paid app
  via Play Console, no IAP, no ads): not scoped, not started. A
  request to add paywall/subscription infrastructure has already been
  declined more than once for contradicting the offline, zero-IAP
  architecture — any future ask needs a new, explicit architecture
  decision, not a quiet addition.
- Hajj/Umrah/pilgrimage guide: fully removed from the repo
  (2026-08-26). If revisited, it's a rebuild from git history, not a
  re-enable.
- Streak tracker: cut from v1, not scoped.
- Qibla's real/redesigned screen: deferred until the rendering glitch
  has an actual fix — see Current Status above. This is a bug-fix
  blocker, not a design decision still pending.

## Anti-Drift Rule (design changes must be provably different)
- Never mark a design/UI task done from source-reading alone. Take a
  screenshot before and after, and confirm the diff is real.
- Bump the build stamp (commit hash + run number) on every change so
  "already implemented" can be checked against what's actually
  installed, not assumed from the repo.
- If a requested change doesn't visibly appear after a build, treat
  that as a bug to fix — not as "done, ship it anyway."
- Quote the exact token/value changed in the commit message or
  summary. If you can't name the specific value that changed, nothing
  changed.

## Monetization Timeline
Launch **free** on the Play Store listing (1-month launch window),
then flip the listing from free to paid in Play Console — a
store-level setting only, no app rebuild, no code change. Existing
installs stay free forever; new installs pay from that point on.
Still locked: no IAP, no billing/subscription library, no ads, no
INTERNET beyond the one documented exception, ever. If in-app
monetization is ever genuinely wanted, that's a new architecture
decision to make explicitly — not a quiet "spec update."

## Language Scope (v1)
English + Tamil complete for v1. Sinhala follows in a post-launch
update — do not block v1 release on finishing Sinhala translation.
Existing Sinhala strings/infrastructure stay in the repo; the gap is
in coverage completeness, not architecture.

## Update & Release Safety
- Every release: bump the version in `pubspec.yaml` (name + build
  number) before tagging.
- Ship as AAB, not APK.
- Any database schema change must come with a matching migration in
  `DatabaseHelper`'s upgrade path — never assume fresh-install-only is
  enough once real users have real data saved.
- All tests must be green before any release is tagged.
- Recommend a staged rollout in Play Console for every post-launch
  update — flag it as a reminder each release; it's a Play Console
  setting, not app code.

## Religious Content
Never generate Quranic text, Arabic duas, or Tamil/Sinhala religious
text. Quran text: Tanzil Project only, verified before commit. Azkar
gaps: cross-check Hisn al-Muslim before adding any new entry. If a
source can't be verified, leave it flagged rather than filling it in.

## Token Efficiency
No conversational filler, no restating the task. Output working code
directly, in complete modular blocks. Stop when the requested item is
done — don't scope-creep into the next one uninvited.

## Recent History (see CLAUDE_HISTORY.md for full detail)

**Week of 2026-08-23–27**: v1 scope locked (Hajj/Umrah and streak
tracker cut, Sri Lanka holidays kept, Tamil complete/Sinhala deferred,
monetization sequencing set). Fixed the Quran/Azkar stuck-spinner bug
(CRLF asset checkout) and a real Overlay-during-build crash in the
shared particle-burst effect. Verified religious text against source
assets programmatically. Shipped the Iqama-gap Home state and Azkar
bookmarking. Settled that hot-reload isn't usable in this environment
— full rebuild + `adb install -r` is the standing method.

**Week of 2026-08-28–31**: Built a real Nebula/Dawn light theme.
Live-reproduced Qibla's rendering bug via screen recording. Reversed
the "single reciter" decision — shipped 5 selectable Adhan reciters.
Went through several rounds of a full Qibla redesign chasing the same
glitch across multiple root-cause theories, never conclusively fixed.
Rejected several uploaded documents that fabricated user authorization
or referenced APIs that don't exist in this repo. Shipped the Progress
screen redesign, a tap-only Tasbih device, calendar reminders, and
converted Quran reading to continuous flowing text.

**Week of 2026-09-01–04**: Converted both Quran readers to real
page-turn navigation. Added gyroscope fusion to the compass sensor
service, but confirmed via pixel-diffed screenshot bursts that the
Qibla needle was still broken regardless — most likely a
GPU/compositor issue, not app logic. Corrected the real Azkar/Dua
count (74, not ~150). Narrowed the fresh-install pre-checked-prayers
bug to something reinstall-specific. Documented the exact CI
release-signing secret fix needed.

**2026-09-05**: Redesigned bottom nav + More-screen icons as glossy 3D
orb badges after several rounds of visual feedback. Routed Qibla to a
"coming soon" placeholder rather than shipping the still-broken
screen. Found and fixed a real bug: onboarding was re-appearing on
every quick reload regardless of completion status. Unblocked a local
web-preview build for icon review only (gated behind `kIsWeb`, never
affects a real device or the test suite — this app still does not
target web). Added a branded loading indicator to Quran's loading
states. Opened PR #9 with all of this; refined this file (moved the
full diary to CLAUDE_HISTORY.md, added the efficiency/reporting
standing rules).
