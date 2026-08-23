---
name: noor-hijri-calendar
description: Use for any work on the Islamic/Hijri calendar feature, including Sri Lankan holiday overlays.
---

# noor Hijri Calendar

## Known open item
Sri Lankan holidays on the calendar are tracked in CLAUDE.md Build
Loop Phase 2 — check current status before starting new work.

## Structure
Hijri date conversion logic in `logic/`, Sri Lankan holiday data (a
bundled, offline dataset — not a live lookup) in `data/`, calendar grid
and detail views in `presentation/` following noor-design-system.

## Note on holiday dates
Hijri-calendar-based holiday dates shift yearly relative to the
Gregorian calendar and can vary by local moon-sighting practice.
Bundle a clearly-dated dataset and note in the UI (or About page) when
it was last verified, rather than presenting dates as permanently
fixed.
