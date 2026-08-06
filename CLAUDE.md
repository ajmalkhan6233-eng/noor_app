# CLAUDE.md — standing rules for this repo

Bismillahir Rahmanir Raheem — watermark: ALLAH

These are standing rules for every future Claude Code session working
on **noor**, not a one-time task list. They exist because each one was
learned the hard way in an earlier session — read the "why" under each
one before assuming it doesn't apply to what you're doing.

See also `.clinerules` for the underlying architecture rules (offline-
first, 150-line file limit, decoupled layers, etc.) — this file is
about *process*, that one is about *code shape*.

## 1. Report on every part of a multi-part request, explicitly

When given a multi-part prompt (numbered tasks, a list of gaps, several
requested commits), report back on **every part** before considering
the work done — even "investigated, found nothing changed" is a real
report. Never silently drop part of a request because it turned out to
need no code change, or because a later part took longer to verify.

*Why:* a splash-screen investigation was completed correctly but its
finding wasn't surfaced to the user for two full requests running —
the work existed, but from the user's side it looked ignored.

## 2. Don't trust source-reading alone once a real device disagreed

Never claim something is "already correct" based on reading source
code alone when there's any prior report of it looking wrong on a real
device or in a real build. Prove it with an actual widget test, golden
test, rendered-pixel check, or equivalent. Source-reading has missed
real problems on this project more than once — code that looks right
and code that renders right are not the same claim.

If the strongest available proof (e.g. `RenderRepaintBoundary.toImage`
pixel capture) hangs or is unavailable in the sandbox, fall back to the
next-most-direct check (e.g. inspecting the actual resolved `TextStyle`
built by the live widget tree) and say plainly which level of proof you
actually got — don't silently downgrade to a source read and call it
verified.

## 3. "Pushed" is not "confirmed working" — wait for CI to go green

Always confirm CI actually finished and went green (through the real
APK build and release-publish steps, not just analyze/tests) before
reporting something as done. A push that triggers a build is the start
of verification, not the end of it.

## 4. Never break the on-screen build identifier

The build stamp (commit short-SHA + CI run number, currently shown at
the bottom of the Home dashboard via `BuildInfo`) exists specifically
so a human looking at an installed APK can tell which commit it
actually contains. Keep it working and visible on every build. If a
change touches `BuildInfo`, the CI workflow's `--dart-define` wiring,
or the Home dashboard layout, verify the stamp still renders before
calling that change done — `test/widget_test.dart` asserts on it for
exactly this reason; don't weaken or remove that assertion.

## 5. Check recent history before touching shared/core files

Before editing colors, the database schema/helper, or other shared
constants (`app_colors.dart`, `database_helper.dart`, anything in
`core/constants/`), check whether a recent commit already changed that
file for a reason — `git log -p` on the specific file, not just the
overall repo. An old patch or a stale local copy silently overwriting
newer working code has caused a real (if brief and never-shipped)
regression here before.

## 6. Prefer several small, separately-verified commits over one big one

Even when a single prompt asks for many things at once, split the work
into small, independently committed and independently tested changes:
`flutter analyze` + `flutter test` before each commit, one commit per
logical change, push and confirm CI green before moving to the next.
One failing or half-finished piece should never block or hide the
others — and when reporting back, each piece gets its own clear
done/not-done/blocked line (see rule 1).

## 7. Religious text is never AI-generated — always sourced and verified

Quran text and translations, azkar, duas, and Hajj/Umrah rite
descriptions are never authored or paraphrased by the assistant, in
any language, at any confidence level. Every such string ships from a
verified, appropriately-licensed source (Tanzil, a specific attributed
GitHub mirror, Hisn al-Muslim, etc.), imported with the same
checksum-verification and attribution discipline already used for the
existing Quran text (`assets/quran/`, `assets/quran_translations/`)
and the Talbiyah (`assets/talbiyah/`) — SHA-256 the exact bytes,
record where they came from and under what license in that asset
directory's `README.md`, and refuse to display anything that doesn't
verify. If no suitably-licensed source can be found for a given
category or language, ship nothing for it and say so plainly — an
empty "not loaded yet" state is always correct; invented or translated-
by-the-assistant text is never acceptable, regardless of how confident
or plausible it looks.
