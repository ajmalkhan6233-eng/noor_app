---
name: noor-accessibility
description: Use whenever building or editing any interactive widget in noor — buttons, toggles, list items, counters, sliders. Every interactive widget requires explicit Semantics(). Also use when auditing an existing screen for VoiceOver/TalkBack coverage.
---

# noor Accessibility

## Rule
Every interactive widget wraps in `Semantics()` with:
- `button: true` (or the correct role) where applicable
- `label`: what the element is
- `value`: current state, if it has one (e.g. a counter's count)
- `hint`: what happens on activation, if not obvious from the label

See `lib/features/tasbih/presentation/widgets/haptic_counter_button.dart`
for the reference pattern.

## Checklist when touching any screen
- [ ] Every tappable element has Semantics with label + hint
- [ ] Elements with dynamic state (counters, toggles, progress) expose
      that state via `value`
- [ ] Decorative-only elements (particles, glow layers) are marked
      `excludeSemantics: true` so screen readers don't announce them
- [ ] Screen reads in a sensible order top-to-bottom — check with
      `Semantics(sortKey: ...)` if the visual order and reading order
      diverge (common with layered/glass designs)
- [ ] Color is never the only signal (e.g. milestone glow should pair
      with a haptic and/or a value change, not rely on sight alone)
