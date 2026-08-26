---
name: noor-audit-reconciliation
description: Use whenever acting on a bug list from an external audit, review, or prior report (Antigravity, a screenshot, an old ticket). Prevents wasted work re-fixing things that are already fixed, and prevents missing things that are still genuinely broken.
---

# noor Audit Reconciliation

## Why this matters
More than once, an external audit's bug list turned out to be checking
against an older snapshot of the code — several items it flagged as
broken were already fixed by the time they were re-checked directly
against the actual files. Blindly re-applying every claimed fix wastes
effort and risks reintroducing already-solved problems; blindly
trusting "it's probably fine" risks missing something real.

## Rule
For every item on an external bug list, before touching any code:
1. Check the actual current file/behavior directly — don't assume the
   report is current just because it's detailed or recent.
2. If already fixed: note it as already-resolved, don't re-touch it,
   move to the next item.
3. If genuinely still broken: fix it, and note explicitly that it was
   confirmed broken firsthand, not just assumed from the report.
4. Report back per-item which category each one fell into — "already
   fixed, verified directly" is a different, more useful status than
   "fixed" alone.

This is the mirror image of noor-build-verify (which prevents
reporting *your own* work done without checking) — this one prevents
trusting *someone else's* claim of brokenness without checking either.
