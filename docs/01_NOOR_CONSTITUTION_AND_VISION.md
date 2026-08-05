# noor (نور) — Constitution & Vision

**Status:** Reconstructed from project history, 5 August 2026.
**Source:** Master Requirements Document v0.1, section 1 (Product Vision).

---

## 1. What noor is

noor is a privacy-first, fully offline Islamic utility app for Android,
built for Sri Lankan Muslim users, targeting the Google Play Store.

## 2. The core differentiator (non-negotiable)

The privacy claim is **architectural, not promised**. noor makes zero
network calls, embeds zero analytics SDKs, zero advertising SDKs, and ships
with **no INTERNET permission in the Android manifest at all**. It is
therefore structurally incapable of transmitting user location or behaviour
— not "won't," but "can't."

This decision traces to a real precedent: in 2020, Motherboard reported that
Muslim Pro supplied granular location data to the data broker X-Mode, which
sold it onward to US defence contractors. Muslim Pro denies ever selling
data and ended those relationships after the report. noor's answer is to
make the entire *class* of failure impossible rather than rely on a policy
promise that a future version, a future team, or a future acquisition could
quietly reverse.

## 3. Quality bar

Polish and completeness on par with Muslim Pro and Athan — while exceeding
both on privacy and on honest handling of religious calculation.

## 4. Religious accuracy is the highest-severity requirement class

Any requirement tagged `RA-` in the Master Requirements Document is
blocking without exception, traded against nothing — not schedule, not
scope, not a user's impatience. The reasoning stated at the time: a bug in
the Tasbih counter is an annoyance; a wrong Isha time is someone praying
incorrectly every day without knowing it.

Concretely, this means:
- Calculation method and madhab are always **user-chosen**, never assumed.
- Prayer times are cross-checked against a real external authority across
  multiple cities before release.
- Quran text is never model-generated, under any circumstance, at any
  confidence level. It is sourced from the Tanzil Project and
  checksum-verified before display — the app refuses to show anything if
  verification fails. This caught a real defect (a spurious shadda in the
  Bismillah of Surahs 95 and 97) that a simple line/word count would have
  missed.

## 5. Who this is for

Sri Lankan Muslim users specifically — prayer times use Iqamath times
distinct from adhan, district presets so GPS isn't required, and full
trilingual support in English, Tamil, and Sinhala.

## 6. Charity

Solicited discreetly — not a growth mechanic, not gamified, not pushed.
