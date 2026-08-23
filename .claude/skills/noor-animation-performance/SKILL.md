---
name: noor-animation-performance
description: Use whenever adding or reviewing any animation, particle effect, or timer-driven UI update. Prevents jank, battery drain, and unnecessary rebuilds — a real bug already found once (a widget re-querying the database every second from a UI timer).
---

# noor Animation Performance

## The bug that already happened
`ayah_of_day_card.dart` was re-triggering a database query on every
1-second timer tick, because its future wasn't cached across
rebuilds. Any new timer-driven or animated widget must be checked
against this exact pattern before it ships.

## Rules
- Cache futures/data fetches outside the rebuild path — a timer that
  updates a countdown display should never cause a new database or
  file read on every tick.
- Dispose every `AnimationController` in `dispose()` — a leaked
  controller keeps animating off-screen and drains battery.
- Prefer implicit animations (`AnimatedContainer`, `AnimatedSwitcher`)
  over a raw `AnimationController` unless the effect genuinely needs
  fine-grained control.
- Particle effects (per noor-kinetic-typography) are for meaningful
  moments, not continuous background motion — a particle system
  running permanently in the background is a battery drain for no
  benefit on a prayer/utility app people keep open for a countdown.
- Target 60fps. If a new effect visibly stutters on a mid-range
  device, it's not done — simplify it rather than shipping the
  stutter.
