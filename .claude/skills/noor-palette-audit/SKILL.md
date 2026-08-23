---
name: noor-palette-audit
description: Use to find and eliminate any remaining legacy AppColors.emerald (#14603C) or other non-token color usage anywhere in lib/. This has recurred more than once — treat it as a real, repeatable check, not a one-time fix.
---

# noor Palette Audit

## Why this is its own skill
Legacy emerald (`#14603C`) has turned up repeatedly in AppChip,
MoreScreen, ZakatResultCard, AyahTile, loaders, the Qibla compass
needle/labels, the Tasbih reset button, prayer list borders, and
navigation — despite the palette being locked. One sweep isn't
enough; this needs to be a repeatable check run any time UI code is
touched.

## How to run it
1. Search the entire `lib/` tree for hardcoded hex values and for
   `AppColors.emerald` (or any color not defined in
   `app_colors.dart`).
2. Every hit gets mapped to the correct locked token: Gold (`#FFB703`)
   for primary accents/active states, Cyan (`#00F2FE`) for
   secondary/telemetry accents, per noor-design-system.
3. Confirm no new hardcoded hex values were introduced by whatever
   change is being made right now — this audit runs both backward
   (find old leftovers) and forward (prevent new ones).

## Rule
If a widget needs a color not in `app_colors.dart`, that's a sign a
new semantic token might genuinely be needed (e.g. a distinct warning
color already exists) — add it properly to `app_colors.dart` with a
reason, don't hardcode a one-off hex value inline.
