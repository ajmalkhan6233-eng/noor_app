# Overnight log

Resume rule: read this file, continue at "NEXT". Never redo DONE items.
Work dir: worktree `zealous-merkle-5d5e7c`. Local `main` is checked out (dirty) in the repo root, so merges are done on branch `main-merge` (from origin/main) and pushed with `git push origin main-merge:main`.

## JOB 1 (Parts A-E)
- DONE A: feat/progress-card, feat/theme-mushaf, feat/theme-emerald-night (built from scratch; no earlier work existed), fix/bugs-overnight (3 fixes: day rollover, theme-name fallback, double-tick), chore/bug-report. All pushed.
- DONE B1: fix/spacing-unify merged into main-merge (analyze 29, 328 tests).
- DONE B2: feat/theme-emerald-night (contains mushaf) merged (analyze 29, 337 tests).
- IN PROGRESS B3: feat/progress-card merged (l10n conflict resolved by union of ARB keys + regen); test run pending.
- NEXT: B4 fix/bugs-overnight, B5 chore/bug-report, push main, Part C build (gh workflow "Build arm64-only APK" --ref main), Web Preview check, Part D branch cleanup (only if build green), Part E checklist.

## JOB 2 (polish: phases 1-5)
- NEXT after job 1: branch polish/overnight from main; FINDINGS.md (50), fixes, IMPROVEMENTS.md (50), quality gate, PLAY_STORE_READINESS.md, merge, build, cleanup.
- Hard rule: prayer method/settings, Quran text, azkar/dua text, Qibla math, religious wording -> NEVER change; log in docs/NEEDS_DECISION.md.
