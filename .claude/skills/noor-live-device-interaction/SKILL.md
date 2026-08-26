---
name: noor-live-device-interaction
description: Use whenever tapping, navigating, or interacting with the app on a real connected device to verify behavior. Prevents acting on stale screen state.
---

# noor Live Device Interaction

## Rule
Re-screenshot immediately before calculating tap coordinates — never
reuse a screenshot from even a few steps earlier. The screen can have
scrolled, changed tabs, or updated since the last screenshot was
taken, and a stale screenshot produces a confidently wrong coordinate
(a real example: a miscalculated tap landed on the wrong bottom-nav
tab entirely because the coordinate was based on an earlier screen
state).

## Silver lining worth remembering
A "wrong" tap isn't always wasted — it can still produce useful data.
Landing on the wrong tab by accident is still evidence that tab loads
correctly, which can help rule bugs in or out elsewhere. Note
incidental findings like this rather than discarding them as noise.

## Practical flow
1. Screenshot.
2. Locate the target element's real coordinates from *that*
   screenshot.
3. Tap immediately.
4. Screenshot again to confirm the result before the next action.
Don't batch multiple taps against one screenshot.
