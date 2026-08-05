# noor (نور) — Islamic Engine

**Status:** Reconstructed from project history, 5 August 2026. This is the
domain-logic companion to the System Architecture doc — everything that
touches religious accuracy (`RA-`, `DS-` requirements) lives here.

---

## 1. Prayer times

- Calculation delegated to the `adhan` package (ADR-4) — no bespoke
  astronomical math.
- Calculation method and madhab are **user-selected**, never assumed
  (RA-1).
- Iqamath times are stored and shown **separately** from calculated adhan
  times — this matters specifically for Sri Lankan mosque practice.
- 25 district presets so a user never has to grant location access to get
  correct times.
- Times were cross-checked against a real external authority across
  multiple cities before build 18 shipped (RA-2).

## 2. Qibla (3D compass)

Not a flat dial. Design intent, verbatim from the working notes:

> A qibla that's genuinely 3D — the Kaaba rendered in perspective, the
> horizon tilting with your phone, depth rather than a flat dial.

Implementation requirements:
- Magnetic declination corrected, not raw compass heading.
- Sensor readings smoothed by averaging as **unit vectors**, not averaging
  raw angle numbers — the detail that catches most naive implementations
  (naively averaging 359° and 1° gives 180°, the wrong direction).
- An honest calibration warning is shown when sensor accuracy is poor,
  rather than confidently pointing an arrow in an unreliable direction.

## 3. Quran text integrity (DS-1)

- Source: **Tanzil Project (tanzil.net) only.** No Quranic text, Arabic
  dua, or Tamil/Sinhala religious text is ever model-generated, at any
  confidence level, under any circumstance.
- The bundled text asset is checksum-verified at build/load time. If
  verification fails, the app refuses to display the affected text rather
  than showing something unverified.
- This check is not theoretical — it caught a real defect during
  development: a spurious shadda in the Bismillah of Surahs 95 and 97 that
  a simple line-count or word-count check would not have caught.
- 6,236 ayahs, full search, bookmarks, last-read position persisted.

## 4. Azkar (DS-2)

- Morning (26 items) and evening (24 items) azkar imported from an
  MIT-licensed source with per-item attribution — shipped.
- After-prayer, sleep, and travel azkar have **no confirmed licensed
  source**. Rather than generate text to fill the gap, these categories
  ship as an explicit empty state. This is a deliberate, standing decision,
  not an oversight — do not fill these with generated text.

## 5. Zakat calculator

- Nisab thresholds: **87.48g gold / 612.36g silver**, per standard fiqh
  reference values.
- Live gold/silver prices are user-editable (never fetched — no network
  calls).
- Behaviour verified specifically at and around the nisab threshold, since
  that boundary is where a rounding or comparison bug would silently give
  a wrong zakat obligation.

## 6. Hajj & Umrah guide

- English guide text: shipped.
- Tamil and Sinhala religious text: **blocked** — no licensed source
  identified. Same rule as azkar: an empty state, not generated text.
- Tawaf and Sa'i counter assistant, including **idtiba** and **ramal**
  reminders. Ramal was missing from the original specification and was
  added after verification against six independent sources.
- Explicit guidance in the requirements: prayer times, qibla, and tasbih
  are safe for an inexperienced user (e.g. an elderly relative) to rely on;
  the ritual guide itself is unverified for that purpose and should not be
  the sole reference for performing Hajj.

## 7. Standing rule across all of the above

No feature in this list is an exception to DS-1/DS-2: if a licensed,
attributable source doesn't exist for a piece of religious text, the
correct behavior is an empty state, not a generated fill-in — regardless of
how small or well-known the passage seems.
