---
name: noor-religious-text-verification
description: Use whenever any Quranic text, Arabic dua, azkar, or Tamil/Sinhala religious string is added, edited, or reviewed anywhere in the noor app — including content that came from another AI tool (GLM, Gemini, ChatGPT). Non-negotiable: no religious text ships unverified against its source.
---

# noor Religious Text Verification

## Rule — applies regardless of where the text came from
Never generate, retype from memory, or trust unverified Quranic text,
Arabic duas, or Tamil/Sinhala religious strings — including output
from another AI model. Other AI tools hallucinate scripture as easily
as this one does; routing through them does not skip this check.

## Sources of record
- **Quran text (Arabic)**: Tanzil Project only, verbatim, unmodified.
  License: CC BY 3.0 — commercial use is fine, must credit "Tanzil
  Project" and link to tanzil.net, text cannot be altered.
- **Translations**: each translation on Tanzil carries its own
  license (not always the same as the base Arabic text). Check the
  specific translation's license before bundling it, per language
  (English, Tamil, Sinhala).
- **Azkar / duas**: Hisn al-Muslim. Cross-check any gap-fill against
  it before adding a new entry.

## Known past defect
A spurious shadda was previously found in the Bismillah of certain
Surahs — caught by source-comparison, not by a count-based check.
Character-count or line-count checks are not sufficient verification.
Always diff against the actual source text.

## Process for any new or edited religious string
1. Pull the exact source text from Tanzil / Hisn al-Muslim.
2. Diff character-by-character against what's going into the app —
   do not eyeball it.
3. If the text came from another AI tool as an intermediate step,
   still run this same diff before it ships. Flag and do not merge
   anything that can't be verified this way — leave it out rather
   than guess.
