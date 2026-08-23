---
name: noor-visual-self-qa
description: Use before marking any visual/design task complete. Requires an actual rendered check — not source-reading — from four angles (design fidelity, accessibility, performance, palette correctness) before reporting done.
---

# noor Visual Self-QA

## What this is, honestly
This is Claude Code checking its own work from four specific angles
before calling something finished — not independent reviewers, not a
council, not real outside people. Framed that way deliberately: a
single careful pass done four ways is genuinely useful; pretending
otherwise would be misleading.

## The four checks, every time, before marking a visual task done
1. **Design fidelity** — does the built, rendered result actually match
   what was asked? Screenshot it (or check the GitHub Pages preview)
   and compare directly against the request or reference image. See
   noor-build-verify and noor-design-system's anti-drift rule — this
   is the same discipline, applied specifically to this design pass.
2. **Accessibility** — does the change still satisfy noor-accessibility
   (Semantics labels/values/hints intact, nothing color-only)?
3. **Performance** — does the change satisfy noor-animation-performance
   (no jank, no unnecessary rebuilds, controllers disposed)?
4. **Palette correctness** — does the change satisfy noor-palette-audit
   (only locked tokens used, zero legacy emerald)?

## Reporting
When reporting a visual task complete, name which of the four checks
were done and what was found — not just "done." If a build/screenshot
genuinely isn't possible in the moment, say so explicitly rather than
skipping the check silently.
