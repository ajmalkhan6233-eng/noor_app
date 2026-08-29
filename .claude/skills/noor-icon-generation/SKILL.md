---
name: noor-icon-generation
description: Use whenever a new or replacement app icon is needed (launcher icon, nav icons, feature icons). Covers code-drawn vector icons — the working, offline-friendly approach — not AI image generation, which isn't available in this environment.
---

# noor Icon Generation

## The real approach — code-drawn, not AI-generated
There is no local image-generation model available in this
environment. Attempting to "generate an image" will fail. The correct
and already-proven approach: draw icons programmatically using shapes,
paths, and the locked palette — exactly how the current launcher icon
was made (gold circle + cyan diamond on obsidian, built with
System.Drawing/Canvas primitives, not an AI image).

This isn't a workaround — it's genuinely the better fit for this app:
vector/code-drawn icons stay crisp at any size, add no bitmap weight
to the app, and are trivially recolored to match theme changes.

## Process
1. Define the icon as simple geometric shapes (circles, polygons,
   paths) using the locked palette (obsidian/gold/cyan).
2. Render via Canvas/CustomPainter (in-app icons) or a script using
   System.Drawing or similar (static launcher/notification icons).
3. Export to the required sizes/densities in one pass rather than
   redrawing per size.
4. View the rendered result before committing — confirm it actually
   looks like an icon, not just that the code ran without error.

## If a genuinely custom illustration is ever needed
That would require an external image generator (used outside this
environment) producing a file that gets added as a static asset — not
something to build a skill around, since it's a one-off asset
decision, not a repeatable coding pattern.
