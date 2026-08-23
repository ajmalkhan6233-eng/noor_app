---
name: noor-git-release-workflow
description: Use when committing, pushing, or working through the CLAUDE.md Build Loop phases. Covers commit conventions, CI behavior, and how to verify a push produced the expected result.
---

# noor Git & Release Workflow

## Commit habits
- Commit after each checked-off Build Loop item, not in one giant
  batch at the end of a session — smaller commits make it possible to
  tell which change fixed or broke what.
- Commit message states the specific thing that changed (see
  noor-design-system's rule on naming the exact token/value changed,
  where relevant).

## CI
GitHub Actions auto-builds on every push to `main` — no manual
workflow dispatch needed. After pushing:
1. Confirm the Actions run succeeds (don't assume — check).
2. If a GitHub Pages preview is configured, confirm it updated and
   reflects the change (see noor-build-verify).

## Working through the Build Loop
Follow CLAUDE.md's phases top to bottom. Don't jump ahead to a later
phase while an earlier item is open. Report status against the actual
checklist, not a general summary — say which items moved from
unchecked to checked this session.

## Before Phase 4 (submission)
Confirm every Phase 3 item first — signing keystore, AAB build,
Keystore-backed DB passphrase, privacy policy, and no INTERNET
permission anywhere in the manifest or dependency tree. Submission
readiness is a hard gate, not a suggestion.
