# OPUS AUDIT BRIEF — Noor (written 2026-11-19)

You are Opus 5.5, senior auditor. AUDIT ONLY. Do not change app code. Read the code yourself (repo is cloned at /home/claude/noor_app; base = branch fix/launch-blockers-credits-restore-guard, which includes the 18 Nov fixes). Start with `usage` check; stop at 40% weekly and say so. Do not ask Aj questions: write concerns to AI_MEMORY/LIVE.md and use the safe default. Never build on the PC; builds run in GitHub Actions only.

## WHAT AJ WANTS (locked decisions)
1. SPEED FIRST. The app must feel instant, light and simple, like the iPhone phone app.
2. SPLASH: remove the animated sequence. Show the brand ("Bismillah" + "Noor") as a static screen for a few hundred milliseconds at most, then the app loads at once. No waiting on animations.
3. QURAN AUDIO: tapping any ayah must start sound within ~1 second (like the Athan app). Find every cause of delay (player creation, asset-to-file copy, no preloading, DB reads, rebuilds, download service).
4. VISUALS: by default plain and simple (system-like, light, no gradients, no blur, no glow, no particles, no glossy orbs, no sky engine, no shockwave). ALL rich styling (dark + gold Cosmic colours, animations, effects) goes behind ONE switch in Settings, default OFF.
5. Free forever. No ads, tracking, billing. Offline-first (only exception: optional Quran audio download).
6. Qibla is NOT part of this audit (separate task later). Keep it hidden.

## SCOPE (check everything)
A. Startup time: main.dart, app.dart, splash, DB open, theme load, plugin init, fonts, heavy first frame work.
B. Quran: reader, pagination, audio start path, bookmarks, search, memory use, jank.
C. Visual weight: list every animation, particle, BackdropFilter, gradient, CustomPainter, timer-driven rebuild; say what to remove or move behind the switch. Check the 4+ existing themes and propose the least risky way to get "Simple (default) + one Rich toggle".
D. Prayer times / Adhan / alarms: accuracy vs Sri Lanka (ACJU) timetable, exact-alarm flow, notifications, boot reschedule, duplicate schedulers.
E. Permissions, privacy, network (see docs/AUDIT_2026-11-18.md items 5, 9, 11).
F. Audio: size (44 MB bundled), licences, attribution, download manager.
G. Database/backup (SQLCipher, migrations, the restore guard added 18 Nov).
H. Dependencies and 16 KB alignment, release pipeline/signing.
I. Rules conflicts: .clinerules, CLAUDE.md (Cosmic-only and "no new look" rules must change for decision 4), old free-to-paid lines.
J. Accessibility (Semantics), Tamil text (Sinhala not done), tests.

ALREADY FOUND (do not redo, verify only): docs/AUDIT_2026-11-18.md.
UNVERIFIED so far: flutter analyze/test, AAB build, anything on a real phone. Say which of your findings you could and could not execute.

## OUTPUT (write only docs/OPUS_AUDIT_REPORT.md on a new branch audit/opus-report; push it)
1. Executive summary: max 10 lines.
2. Speed findings: measured or estimated cost of each delay, with file:line.
3. FIX QUEUE, ranked most important first. For every item:
   - ID, title, severity
   - Size: HAIKU (small, 1 file) / SONNET (medium) / OPUS (hard)
   - Exact files and the exact change
   - Check step (a test or cloud check that proves it)
   - Needs Aj's approval? yes/no
   Group into: LAUNCH BLOCKERS, SPEED, SIMPLE LOOK, SAFETY/LEGAL, CLEANUP.
4. Conflicting rules and the corrected rule set.
5. What was NOT checked.
Keep each item to 5 lines. Aj reads on a phone: finish with a one-screen summary (DONE / NOT DONE / NEEDS AJ, one line each) and one status word.
