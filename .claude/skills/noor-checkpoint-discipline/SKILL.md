---
name: noor-checkpoint-discipline
description: Consult during any multi-step task, especially long or unattended (overnight) sessions. Ensures partial progress is never lost and any future session can pick up cleanly.
---

# noor Checkpoint Discipline

## Rule
On any multi-item task:
- Commit each finished, verified item individually — never batch many
  changes into one commit at the end, since a usage limit or session
  interruption can hit at any point.
- Log progress plainly in CLAUDE.md as you go, not only at the end —
  what's done, what's in progress, what's next.
- If work must stop before the full list is finished (usage limit,
  genuine blocker), stop at a clean point: nothing half-edited,
  nothing uncommitted, and the log clearly states exactly where things
  stopped and what the next step is.

## Why this matters here
Long unattended sessions are common on this project, and the person
running it isn't always available to check in mid-task. A session
that dies or runs out of usage mid-change, with nothing committed and
no log entry, wastes the entire session's work — even if most of it
was actually done correctly.

## Good stopping point checklist
Before ending any session, confirm: latest change is committed, tests
pass on that commit, and CLAUDE.md's log states plainly what was
finished and what remains — so a fresh session (or the person) can
resume without re-discovering any of it from scratch.
