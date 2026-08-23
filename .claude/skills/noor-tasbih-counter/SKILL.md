---
name: noor-tasbih-counter
description: Use for any work on the tasbih (dhikr counter) feature — the counting Cubit, haptic milestones, orb visuals, or drag interactions.
---

# noor Tasbih Counter

## Already scaffolded
`TasbihState`, `TasbihCubit`, and `HapticCounterButton` exist under
`lib/features/tasbih/`. Extend these rather than rewriting from
scratch — check current state first.

## Behavior contract
- Light haptic on every tap, heavier double-pulse at 33/66/100 — this
  lives in `HapticService`, called from `TasbihCubit.increment()`.
  Don't call `HapticFeedback` directly from a widget.
- `reset()` clears the count with a lighter selection-click haptic.
- `setDhikr()` switches the active dhikr phrase and resets the count.

## Known open item
Orb color/drag behavior polish is tracked in CLAUDE.md Build Loop
Phase 2 — check status before starting new visual work here, and see
noor-design-system for the token/glow rules the orb should follow.

## If adding new dhikr phrases
Arabic dhikr text goes through noor-religious-text-verification before
it ships — same rule as Quran/Azkar text.
