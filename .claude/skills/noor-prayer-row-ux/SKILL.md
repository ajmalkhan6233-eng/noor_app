---
name: noor-prayer-row-ux
description: Use when building or refining the Prayer Times list/row UI. Captures interaction patterns worth adopting from competitor research (islamtics) — translated into noor's own locked design language, not copied visually.
---

# noor Prayer Row UX

## Source of these ideas
Competitor pattern research (islamtics app). These are interaction
*ideas*, not visual assets — none of their colors, icons, or exact
layout get copied. Everything below renders in noor's own locked
cosmic palette (obsidian/gold/cyan, glass panels) per noor-design-system.

## Pattern 1: Countdown lives inside the active prayer's row
Rather than a separate countdown capsule elsewhere on screen, the
currently-active/next prayer's row itself shows a live countdown and
a subtle progress indicator (e.g. a thin fill bar under the row)
alongside its time. More compact, and the countdown sits exactly where
attention already is.

## Pattern 2: Per-prayer mute icon, inline
Each prayer row carries its own small mute/notification icon at the
row's end — already the direction noor's per-prayer alarm toggles
take; keep this placement pattern when refining that UI.

## Pattern 3: Simple date navigation
"Today" label with left/right arrows for adjacent days, rather than a
full calendar picker for quick day-to-day browsing. Fine to keep the
full calendar available separately for jumping further ahead.

## NOT included here — needs an explicit decision first
A weekly bar-chart "Prayer Tracker" (5 prayers per day, visualized as
bars) closely resembles the streak tracker feature — which was
deliberately cut from v1 in CLAUDE.md's Deferred section. Do not build
this as part of adopting these patterns. If it's ever wanted, that's
a separate, explicit scope decision, not something to slip in via a
UI-pattern skill.
