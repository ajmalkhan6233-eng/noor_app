---
name: noor-hajj-umrah-guide
description: Use for any work on the Hajj/Umrah guide and pilgrimage tracker feature, including the translation gap noted for this section.
---

# noor Hajj/Umrah Guide

## Known open item
Umrah Guide translation gap is tracked in CLAUDE.md Build Loop Phase 2
— check current status and which language(s) are actually missing
before starting new work.

## Content boundaries (declined-request precedent)
Do not reproduce Nusuk app content or any other app's guide content
directly — this project's precedent already declined that. Guide
content should be written/sourced independently, and any Arabic
ritual text/duas still go through
noor-religious-text-verification.

## Structure
Pilgrimage tracker state (steps completed, current stage) is
local-only progress state — follows the same offline, no-sync pattern
as reading progress and streaks. Follow noor-file-architecture for
where the tracker logic vs. UI lives.
