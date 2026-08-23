---
name: noor-prayer-times
description: Use for any work on the prayer_times feature — prayer time calculation, district presets for Sri Lanka, next-prayer countdown, or the monthly timetable view.
---

# noor Prayer Times

## Stack
The `adhan` package handles all calculation — offline, on-device.
Never call a network API for prayer times; the whole point is this
works with zero connectivity.

## Structure (follow noor-file-architecture)
- `data/`: district coordinate presets for Sri Lanka, calculation
  method config, persistence of the user's selected district
- `logic/`: a Cubit that computes today's times + next-prayer
  countdown from the repository, exposes state for the UI
- `presentation/`: countdown capsule, monthly timetable, district
  picker — all read from the Cubit, never call `adhan` directly

## Known open item
Monthly Timetable labels need a pass — check CLAUDE.md Build Loop
Phase 2 for current status before starting new work here.

## Accessibility
Countdown and prayer-time widgets are dynamic state — see
noor-accessibility for how to expose `value` correctly (e.g. "next
prayer, Dhuhr, in 47 minutes" as a single readable value, not a raw
timer digit).
