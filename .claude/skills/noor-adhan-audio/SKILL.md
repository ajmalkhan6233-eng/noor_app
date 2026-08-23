---
name: noor-adhan-audio
description: Use for any work on Adhan (call to prayer) audio — per-prayer playback controls, reciter selection, mute toggle, or alarm scheduling.
---

# noor Adhan Audio

## Known open items (check CLAUDE.md Build Loop Phase 2)
- Per-prayer alarm toggles
- Adhan mute toggle

## Licensing — check before bundling any reciter audio
Same rule as Quran recitation: confirm the specific Adhan audio file's
license permits use in a paid, commercial app before bundling it.
CC-BY-NC sources are not usable now that noor is a paid app. If in
doubt, flag it rather than bundling and hoping.

## Scheduling
Local notification/alarm scheduling only (`flutter_local_notifications`)
— no server-side push, no network time sync. Prayer times themselves
come from the `adhan` package (see noor-prayer-times), computed
on-device, and drive when local Adhan alarms fire.

## Structure
Playback and scheduling logic in `logic/` (of prayer_times or a
dedicated notifications concern per noor-file-architecture — decide
based on whether this stays tightly coupled to prayer_times or grows
enough to warrant its own space), toggle UI in `presentation/`.
