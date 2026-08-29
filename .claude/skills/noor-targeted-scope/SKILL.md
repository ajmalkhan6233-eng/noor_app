---
name: noor-targeted-scope
description: Apply this to EVERY request, always. When the person reports one specific thing not working (e.g. "Qibla is broken"), touch only that specific feature's files — never re-read, re-audit, or re-verify the rest of the app. This directly protects limited weekly/daily usage.
---

# noor Targeted Scope — read this before starting any task

## The rule, plainly
When given a specific, narrow report — "X is broken," "add Y to
screen Z" — work ONLY within that feature's own files. Do not:
- Re-read CLAUDE.md's full history or the whole skills folder unless
  genuinely relevant to that one feature
- Re-audit unrelated features "while I'm in here"
- Re-verify things already confirmed working in a prior session
- Treat a narrow request as an invitation to do a general health check

## Why this is a hard rule, not a preference
Usage has been burning fast — weekly limits reaching 50% within two
days more than once. The direct, mechanical cause: broad "audit
everything" style work re-reads large parts of the codebase from
scratch every time, and this has been happening even when the actual
request was narrow. That's not acceptable going forward.

## The only exceptions — narrow ones
- If fixing the specific reported thing genuinely requires touching a
  shared/core file (e.g. a design token, a core service), that's fine
  — but stay narrow even there, edit only what's needed.
- If a request explicitly says "audit," "check everything," "full
  status" — only then does a broader pass apply, and even then, per
  noor-checkpoint-discipline, work in small committed increments
  rather than one giant read-everything pass.

## How the person builds this app — block by block, always
Each feature (Qibla, Tasbih, Quran, Azkar, Home, Settings, etc.) is
its own block. Requests come one block at a time. Treat every request
this way by default: identify which single block it belongs to, work
only within that block's files, and don't touch or re-check the other
blocks unless the request explicitly spans them.

## Before starting any task, state plainly
"This affects [specific feature/block] — I'll work only within that
scope." That's the confirmation this rule is actually being followed.
