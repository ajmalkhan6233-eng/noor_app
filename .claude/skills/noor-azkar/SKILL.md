---
name: noor-azkar
description: Use for any work on the Azkar / Duas & Dhikr feature — categories, search, bookmarks, or the known stuck-loading and missing-audio bugs on this tab.
---

# noor Azkar (Duas & Dhikr)

## Known open bugs (check CLAUDE.md Build Loop Phase 1 for status)
- Duas & Dhikr tab stuck on a loading spinner
- Audio missing on certain tabs — confirm playback actually works per
  entry, not just that a play button renders (see noor-build-verify)

## Content source
Hisn al-Muslim is the reference for gap-filling any missing azkar
entry. Every Arabic string here goes through
noor-religious-text-verification before shipping — same standard as
Quran text, no exceptions for "shorter" duas.

## Structure
Follow noor-file-architecture: categories/search logic in `logic/`,
azkar data + any bundled audio references in `data/`, cards/search UI
in `presentation/` using the glass-card pattern from
noor-design-system.
