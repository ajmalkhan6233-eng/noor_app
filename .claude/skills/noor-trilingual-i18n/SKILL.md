---
name: noor-trilingual-i18n
description: Use whenever adding, editing, or reviewing English, Tamil, or Sinhala UI strings anywhere in noor, including the country/language picker and any handbook or help content.
---

# noor Trilingual Support (English / Tamil / Sinhala)

## Rule on generated Tamil/Sinhala text
UI copy (button labels, help text, handbook content) can be drafted
directly, but flag it clearly as machine-drafted and recommend native
speaker review before it ships publicly — translation quality and
cultural fit matter for a product representing itself to this
community. This is a lighter-weight check than
noor-religious-text-verification (which is a hard non-negotiable) —
this one is "get it reviewed," not "never generate."

Any actual religious text embedded in Tamil/Sinhala content (translated
duas, Quran excerpts) still goes through
noor-religious-text-verification regardless of surrounding language —
that rule doesn't relax just because it's wrapped in UI copy.

## Structure
Keep string resources organized per-language, loaded via Flutter's
standard localization mechanism (or an equivalent structured
approach) — never hardcode display strings inline in widgets, so a
translation update doesn't require hunting through UI code.

## Known open item
Country picker UI is tracked in CLAUDE.md Build Loop Phase 2.
