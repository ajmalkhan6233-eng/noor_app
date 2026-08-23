---
name: noor-zakat-calculator
description: Use for any work on the Zakat calculator — nisab thresholds, asset categories, or the calculation logic itself.
---

# noor Zakat Calculator

## Structure
Calculation logic (nisab thresholds, per-category zakat math) lives in
`logic/`, never in a widget — see noor-file-architecture. This is
exactly the kind of "business calculation math" that must not sit
inside UI code.

## Correctness matters here
Zakat calculation is a religious obligation for users, not just a
number — get the nisab basis (gold/silver standard) and category rules
right, and make the assumptions visible in the UI (e.g. which nisab
standard is being used, what currency/gold price basis) rather than
hiding them behind a single opaque output number.

## No network
Gold/silver price for nisab must come from a value the user enters or
a bundled reference, not a live price API — a live lookup would
require the INTERNET permission this app doesn't have. If live pricing
is ever wanted, that's a separate architecture decision, not something
to add quietly here.
