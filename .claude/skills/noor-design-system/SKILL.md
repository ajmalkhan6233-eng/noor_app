---
name: noor-design-system
description: Apply or change any visual styling in the noor app — colors, glass panels, glow/particle effects, typography, spacing, motion. Use this whenever a screen's look needs to change, whenever a new widget is built, or whenever the person says a design request "didn't show up" or "looks the same as before." Always consult this before touching any UI file.
---

# noor Design System — Cosmic Expansion (Flutter-native)

## Why this skill exists
Past design requests were repeated ~20-30 times with no visible change
in the shipped app. Root cause was never fully diagnosed — could be
stale builds, could be vague instructions, could be changes made to
the wrong widget. This skill exists so that never happens again.

## Locked tokens — the only colors allowed
Defined in `lib/core/constants/app_colors.dart`. Never hardcode a hex
value inline anywhere else in the app.
- Obsidian background: `AppColors.obsidian` (#05070B)
- Card surface: `AppColors.cardSurface` (#0D1117)
- Gold accent: `AppColors.gold` (#FFB703)
- Cyan accent: `AppColors.cyan` (#00F2FE)
- Glass border: `AppColors.glassBorder`

Do not use Emerald / #0A1912 / #D4AF37 — that palette is retired.

## Component patterns
- **Glass card**: `ClipRRect` + `BackdropFilter(filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16))`, `Container` with `AppColors.cardSurface` at reduced opacity, 1px border in `AppColors.glassBorder`.
- **Glow / shockwave**: `BoxShadow` with `AppColors.gold` at higher opacity + blur radius for emphasis states (milestones, active states). See `haptic_counter_button.dart` for a working example.
- **Particle/energy motion**: `CustomPainter` for anything resembling particles, or Rive if a `.riv` asset exists. Never reach for Three.js/WebGL/React — this is a native Flutter app, that stack isn't available.
- **Motion**: implicit animations (`AnimatedContainer`, `AnimatedOpacity`) or `flutter_animate` for spring-like easing. Avoid raw `AnimationController` boilerplate unless the effect genuinely needs it.

## Before marking any design task done
1. Name the exact file(s) and widget(s) changed.
2. Name the exact token/value that changed (e.g. "border color changed
   from `AppColors.glassBorder` to `AppColors.gold` on the active
   state") — if you can't name it, nothing changed.
3. Build and take a screenshot, or push and refresh the GitHub Pages
   preview. Confirm the diff visually before reporting done.
4. Bump the build stamp so this specific change is traceable in a
   running install.

Do not report a design task complete based on reading the source code
alone.
