---
name: noor-build-verify
description: Use before reporting any task as complete, and whenever the person says a previously "fixed" or "implemented" item still seems missing. Prevents the stale-build trap where code changes exist in source but aren't reflected in what's actually installed or verified.
---

# noor Build Verification

## Why this matters
Many past "missing feature" reports traced back to stale installs, not
missing code. Reports of "already implemented" based on reading source
code alone have repeatedly turned out to be wrong from the person's
point of view, because what they were looking at wasn't the same build.

## Rule
Never report a task done based on source-reading alone. Confirm it in
one of these ways before closing the item:
1. Build stamp: every debug build shows commit hash + run number
   somewhere visible (e.g. on a settings/about screen). Confirm the
   build the person is checking matches the commit that has the fix.
2. GitHub Pages preview: push, wait for the CI build, then check the
   live preview at the project's GitHub Pages URL reflects the change.
3. Screenshot: if neither of the above is available, take a screenshot
   of the actual running build and compare before/after.

## When starting a session
If the person reports something as "still broken" that was previously
marked done, don't argue from the commit log — assume the install they
're looking at may be stale, walk them through confirming the build
stamp, and only then start debugging the actual code if the stamp
confirms it's the current build and the issue persists.
