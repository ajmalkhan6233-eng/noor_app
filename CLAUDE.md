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
- [ ] Al Quran tab stuck on loading spinner
- [ ] Duas & Dhikr tab stuck on loading spinner
- [ ] Ayah of the Day showing empty despite prior completion report
- [ ] Location detection not prompting on first launch
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
- [ ] Per-prayer alarm toggles
- [ ] Adhan mute toggle
- [ ] Proactive location permission prompt
- [ ] App-wide icon weight pass

### Phase 3 — Release readiness
- [ ] Confirm database passphrase is Keystore-backed (see the TODO in
      database_helper.dart — do not ship the placeholder passphrase)
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
