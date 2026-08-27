---
name: noor-honest-estimation
description: Consult before starting any task involving a first-time toolchain setup, a large download, an emulator, or anything with genuine uncertainty in how long it will take. Sets honest expectations before diving in, not 50 minutes into it.
---

# noor Honest Estimation

## Why this exists
Several real sessions on this project turned into long, unexpected
waits — a first Gradle build, an Android SDK/emulator setup, an NDK
download — where the length only became clear well after starting,
with no warning given upfront. The work itself was often legitimate
and unavoidable, but the surprise made it feel like something had
gone wrong even when it hadn't.

## Rule
Before starting anything with these characteristics, say so plainly
first:
- A first-time toolchain or environment setup (SDK, emulator, new
  dependency ecosystem)
- A large download (anything likely over ~200MB)
- Any step historically known to be slow on this project (first
  Gradle build, NDK provisioning, emulator first boot)

State plainly: what's about to happen, why it's likely to take a
while, and a rough real range if one is known from past experience on
this exact project (e.g. "first Windows Gradle build has taken up to
an hour before — expect similar"). This isn't about padding time
estimates defensively — it's about not letting a long wait feel like
a surprise or a failure when it was foreseeable.
