---
name: noor-kinetic-typography
description: Use when animating key numbers or text — the prayer countdown, streak count, Tasbih count — to feel alive rather than static. Covers particle-formed number reveals and precise, second-by-second visible updates, translated into what Flutter can actually do.
---

# noor Kinetic Typography

## The reference mood, translated honestly
The person has referenced cinematic particle-effect visuals (numbers and
letters assembling from light/particles, holographic HUD data readouts).
That's a film VFX reel budget, not a lightweight offline mobile app —
don't attempt to literally match it. What's real and achievable in
Flutter: numerals that visibly *form* rather than snap into place, and
countdowns that read as precise and live rather than static text.

## Where this applies
- The next-prayer countdown (currently updates via a timer — make the
  second-by-second change feel deliberate, not just a text swap)
- Streak count, Tasbih count — any number that changes in front of the
  user should acknowledge the change, not just redraw

## Real techniques (offline, performant, no external deps beyond what's
already in pubspec.yaml)
- Per-digit `AnimatedSwitcher` or a custom digit-roll (like an odometer)
  for the countdown seconds — a real "precision" feeling without
  needing particles at all.
- `CustomPainter` + a lightweight particle system (reuse the existing
  splash particle effect's approach) for a one-time "ignition" moment —
  e.g. when a prayer time is reached — not for every single second tick.
  Constant particle bursts every second would be distracting and a
  battery drain; reserve real particle moments for meaningful state
  changes (milestone reached, prayer time hit), not routine updates.
- Gold/cyan glow pulses (already used on the Tasbih orb) are a cheap,
  effective way to make a number change feel acknowledged.

## Hard rule
Any new animation must pass noor-animation-performance before it's
considered done — a kinetic effect that causes jank or drains battery
is a regression, not an improvement.
