# Tawaf/Sa'i dua source data — provenance and licence

One file: `hisn-tawaf-sai.json` — the two duas shown during the
interactive pilgrimage tracker's Tawaf and Sa'i steps.

`PilgrimageDuaRepository` SHA-256-verifies this file before displaying
anything from it.

    hisn-tawaf-sai.json   sha256: 809d86bafe27c90cab58911609d91751d6391fe6fe61f63b66259e8668465e04

## Source

**Repository:** `asellam/HisnElMuslim` (GitHub), `hisn.json` — the same
source and MIT licence already used for the Talbiyah text
(`assets/talbiyah/README.md`) and the after_prayer/sleep/travel azkar
(`assets/azkar/README.md`).

Two chapter entries were extracted:

- **`tawaf`** — "الدُّعَاءُ بَيْنَ الرُّكْنِ اليَمَانِي وَالحَجَرِ الأَسْوَدِ"
  (the dua between the Yemeni Corner and the Black Stone), Qur'an
  2:201, recited on every circuit — Abu Dawud 2/179, Ahmad 3/411,
  graded hasan by al-Albani.
- **`sai`** — "دُعَاءُ الوُقُوفِ عَلَى الصَّفَا وَالمَرْوَةِ" (the dhikr
  said while standing atop Safa and Marwah, three times) — Sahih
  Muslim 2/888.

Text and hadith references copied verbatim from `hisn.json`; no text
was altered, retranslated, or hand-typed. No English translation
exists in that source for these entries, so they carry Arabic + a
citation only, same as the Talbiyah.

## Coverage

Only these two duas are included — the ones already shown to the user
by name/count during the interactive Tawaf and Sa'i steps
(`TawafStepView`, `SaiStepView`). The full `hisn.json` also contains
duas for other Hajj/Umrah moments (e.g. at the Black Stone, at
Arafah, at rimay al-Jimar) not yet wired into any screen — a natural
next addition if those steps get their own dedicated views.

Tamil and Sinhala translations of this text do not exist in any
verified, licensed source found so far — same open gap as the rest of
the Hajj/Umrah guide (see `docs/06_FEATURE_MASTERLIST.md` items 63-64).
Ships Arabic + citation only until one is found.

## Updating

    shasum -a 256 assets/pilgrimage/hisn-tawaf-sai.json

Set the result as `PilgrimageDuaRepository.expectedSha256`
(`lib/features/pilgrimage/data/pilgrimage_dua_repository.dart`).
