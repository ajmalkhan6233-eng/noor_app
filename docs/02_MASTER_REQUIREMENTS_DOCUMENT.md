# noor (نور) — Master Requirements Document

**Status:** Reconstructed from project history, 5 August 2026. The original
was ~87 numbered requirements across 15 sections; this reconstruction
carries the ID scheme and the requirements confirmed in the retained
record. Treat as a solid skeleton, not a guaranteed-complete copy — see
06_FEATURE_MASTERLIST.md for the fuller item-by-item log.

---

## ID scheme

| Prefix | Meaning |
|---|---|
| `PR-` | Product / positioning requirement |
| `FR-` | Functional requirement |
| `RA-` | **Religious accuracy** — highest severity, blocking without exception |
| `NF-` | Non-functional requirement |
| `DS-` | Data source and licensing |
| `PV-` | Privacy |
| `AC-` | Accessibility |
| `BR-` | Build and release |
| `VT-` | Verification and testing |

Priority levels: **MUST** (blocking for release), **SHOULD** (expected, may
slip one release), **MAY** (optional).

---

## Confirmed requirements

**PR-1 (MUST).** Privacy-first, fully offline Islamic utility app, Android,
Play Store.

**PR-2 (MUST).** Zero network calls, zero analytics/ad SDKs — see
01_NOOR_CONSTITUTION_AND_VISION.md.

**PV-1 (MUST).** No INTERNET permission in the manifest. **Release
blocker — not yet removed as of build 18.**

**PV-2 (MUST).** `android:allowBackup="false"` in the manifest. **Release
blocker — not yet set as of build 18.**

**PV-3 (MUST).** Database passphrase read from Android Keystore-backed
secure storage, never a literal string. **Release blocker — still a
placeholder as of build 18.**

**DS-1 (MUST).** Quran text sourced from the Tanzil Project only, never
model-generated. Checksum-verified before display; app refuses to render on
verification failure.

**DS-2 (SHOULD).** Azkar text requires a licensed source with per-item
attribution. Where no licensed source exists (after-prayer, sleep, travel
azkar), ship an empty state rather than generated text.

**RA-1 (MUST).** Calculation method and madhab are user-selectable, never
defaulted silently.

**RA-2 (MUST).** Prayer times cross-checked against an external authority
across multiple cities before release.

**FR-1 (MUST).** Prayer times with Iqamath times distinct from adhan times.

**FR-2 (MUST).** District presets (25 Sri Lankan districts) so GPS is not
required.

**FR-3 (SHOULD).** Silent mode auto-enabled during prayer.

**FR-4 (MUST).** Notification scheduling survives device restart
(auto-start on boot).

**FR-5 (MUST).** Tasbih counter with haptic feedback, milestone pulses at
33/66/100, draggable positioning, dhikr selection.

**FR-6 (MUST).** Full Quran, 6,236 ayahs, search, bookmarks, last-read
position.

**FR-7 (MUST).** Zakat calculator — nisab 87.48g gold / 612.36g silver,
editable live prices, correct behaviour at and around the threshold.

**FR-8 (SHOULD).** Hijri calendar, monthly prayer timetable.

**FR-9 (MUST).** Qibla — a genuine 3D compass (Kaaba rendered in
perspective, horizon tilts with the phone), magnetic declination corrected,
sensor readings averaged as unit vectors (not raw numbers), honest
calibration warning when accuracy is poor rather than a confident arrow
pointing nowhere.

**FR-10 (SHOULD).** Hajj/Umrah guide with Tawaf and Sa'i counter assistant,
including idtiba and ramal reminders.

**AC-1 (MUST).** Every interactive widget wrapped in explicit `Semantics()`
for VoiceOver/TalkBack.

**NF-1 (MUST).** No single Dart file exceeds 150 lines.

**NF-2 (MUST).** UI, business logic, and repositories fully decoupled —
presentation never calls the database or calculation logic directly.

**BR-1 (MUST).** Release build uses a real signing keystore, not debug
signing. **Blocker — still debug-signed as of build 18.**

**VT-1 (SHOULD).** Automated test coverage beyond the Tasbih feature.
**Not met as of build 18** — Tasbih is the only human-verified feature;
everything else is written but unexecuted-by-a-human code.

---

## Open questions carried from the original document

- **OQ-1:** Qibla compass provenance was unresolved — whether to port logic
  from a reference implementation or build fresh. Resolved in favor of
  building fresh with unit-vector averaging (see FR-9).
