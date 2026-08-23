---
name: noor-quran-reader
description: Use for any work on the Quran reading feature — page/ayah rendering, bookmarks, Ayah of the Day, or Quran recitation audio. Also use when debugging the known "stuck on loading spinner" and "Ayah of the Day empty" bugs.
---

# noor Quran Reader

## Known open bugs (check CLAUDE.md Build Loop Phase 1 for status)
- Al Quran tab stuck on a loading spinner
- Ayah of the Day showing empty despite a prior completion report —
  treat prior "done" reports on this with suspicion, see
  noor-build-verify before assuming it's actually fixed

## Text source — non-negotiable
All Quran text comes from Tanzil Project, verbatim. Every ayah that
goes into the app gets checked via noor-religious-text-verification
before it ships — this includes text that looks right on a quick read.
A prior defect (spurious shadda in Bismillah on certain Surahs) was
only caught by character-level source comparison.

## Script note
The reference AI Studio build used Simple/Imla'i script while claiming
Uthmani Rasm — confirm which script variant is actually being used
and that it's labeled correctly; don't assume the claimed script
matches what's rendered.

## Audio (recitation)
Candidate source everyayah.com is CC-BY-NC — **not usable now that
noor is a paid app**. Do not wire this source in for a release build
until a commercially-licensed alternative or direct reciter permission
is secured. Flag this rather than silently using the NC source.

## Bookmarks / reading progress
Local-only (SQLite via DatabaseHelper), never synced. Follow
noor-file-architecture for where this logic lives.
