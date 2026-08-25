# Azkar source data — provenance and licence

Four files:

- `adhkar-ar.json` — Arabic text, per-item source citation (morning/evening).
- `adhkar-en.json` — English translation, transliteration, and the
  same per-item source citation (morning/evening).
- `hisn-supplementary.json` — Arabic text and source citation for
  after_prayer, sleep, and travel (added later — see its own section
  below; no English translation available for these).
- `hisn-supplementary-2.json` — Arabic text and source citation for
  child_protection, illness, distress, debt, and visiting_grave
  (added 2026-08-25 — see its own section below; same no-translation
  situation as the file above).

`AzkarImportService` SHA-256-verifies the first two before importing,
and separately (via `azkar_supplementary_import.dart` and
`azkar_supplementary_import_2.dart`) SHA-256-verifies the third and
fourth before backfilling them.

    adhkar-ar.json             sha256: 9e0dd6a10d26ddc0e2b36b94098c287644996c7f81b707f8ad24f1ce40b8c821
    adhkar-en.json             sha256: eec053c4138bed6f3ec7dc3c0e06e926a935dca24663788e5b97a0bfb5f71896
    hisn-supplementary.json    sha256: 0f683306e391af8a80c09457a620bd29ef56b7e5c973ebf4339bc30321b335c3
    hisn-supplementary-2.json  sha256: fbd0674bfbce9cde4fa09819c3224307c5b36439837dadeeed4b4df95632c47f

## Source (morning / evening)

**Repository:** `Seen-Arabic/Morning-And-Evening-Adhkar-DB` (GitHub)
**Licence:** MIT — verified by fetching the repo's `LICENSE` file
directly; MIT permits commercial use, redistribution, and
modification, which is why this dataset (and not others considered)
was chosen.

The underlying dhikr texts are drawn by that project from Said bin Ali
bin Wahf Al-Qahthani's and Muhammad Ismail Al-Muqaddam's compilations,
cross-referenced against Hisn Al-Muslim and Sunnah.com. Each entry
carries its own `source` field citing the specific hadith reference —
imported into `azkar_items.source` (`NOT NULL` in the schema) and
shown in the UI under every dhikr, per the dataset's own sourcing and
this app's `.clinerules` requirement that no azkar text ship without
attribution.

## Source (after_prayer / sleep / travel)

**Repository:** `asellam/HisnElMuslim` (GitHub) — the same source and
same MIT licence already used for the Talbiyah text
(`assets/talbiyah/README.md`), re-verified here rather than assumed.
**File:** `hisn.json`, three chapter entries: "الأَذْكَارُ بَعْدَ
السَّلَامِ مِنَ الصَّلَاةِ" (after prayer, 8 items), "أَذْكَارُ
النَّوْمِ" (sleep, 15 items), "دُعَاءُ السَّفَرِ" (travel, 1 item).
Each item's `Text` and `Reference` fields were copied verbatim into
`content` and `source` — no text was altered, retranslated, or
hand-typed. `hisn.json` has no English translation field for these
entries, so `translation` is left `null` for this batch, same as the
Talbiyah entry.

The full `hisn.json` file (133 chapters) covers many more categories
than these three; only the three the app's schema was scoped for at
the time were extracted, to avoid pulling in content the UI had no
category for yet.

## Source (child_protection / illness / distress / debt / visiting_grave)

**Repository/file:** same `asellam/HisnElMuslim` `hisn.json` as above,
re-downloaded fresh (not reused from a cache) and re-verified this
same session before extraction. Five more chapters, chosen because
they were named directly in a feedback request ("protection for
children... travel, illness, distress, debt" and, from a separate
message, "visiting the grave"):

- `child_protection` ← "مَا يُعَوَّذُ بِهِ الأَوْلَادُ" (what children
  are protected with — the Hasan/Husayn ruqyah), 1 item.
- `illness` ← "الدُّعَاءُ لِلْمَرِيضِ فِي عِيَادَتِهِ" (dua for the
  sick when visited) + "دُعَاءُ المَرِيضِ الذِي يَئِسَ مِنْ حَيَاتِهِ"
  (dua of one who has despaired of life), 5 items combined.
- `distress` ← "دُعَاءُ الهَمِّ والحُزْنِ" (dua for anxiety/sorrow) +
  "دُعَاءُ الكَرْبِ" (dua for distress), 6 items combined.
- `debt` ← "دُعَاءُ قَضَاءِ الدَّيْنِ" (dua for settling debt), 2 items.
- `visiting_grave` ← "دُعَاءُ زِيَارَةِ القُبُورِ" (dua when visiting
  graves), 1 item.

Extraction method: the source file was parsed programmatically
(Node.js `JSON.parse`, chapter selected by exact object key match,
titles printed and visually cross-checked against the chapter list
before any file was written) and each item's `Text`/`Reference`
fields copied directly into `content`/`source` — the same "never
hand-typed" rule as the batch above. No English translation exists
for these entries either.

A sixth category — "starting a new job/business" — was also
requested but does **not** exist as a distinct chapter anywhere in
Hisn al-Muslim's traditional structure (it's organized around
situations from the Prophetic Sunnah, not modern occupational
categories). Rather than force-fit an unrelated chapter to that
label, it was left out; flagged back to whoever requested it rather
than guessed.

## Coverage

`morning`/`evening`: 34 items (16 marked for both, 10 morning-only, 8
evening-only), English translation included. `after_prayer`: 8 items.
`sleep`: 15 items. `travel`: 1 item. `child_protection`: 1 item.
`illness`: 5 items. `distress`: 6 items. `debt`: 2 items.
`visiting_grave`: 1 item. All ten of the app's azkar categories are
now populated — none remain genuinely unsourced.

## Updating

    shasum -a 256 assets/azkar/adhkar-ar.json
    shasum -a 256 assets/azkar/adhkar-en.json
    shasum -a 256 assets/azkar/hisn-supplementary.json
    shasum -a 256 assets/azkar/hisn-supplementary-2.json

Set the results as `AzkarImportService.expectedArSha256` /
`expectedEnSha256` (`lib/features/azkar/data/azkar_import_service.dart`),
`azkarSupplementaryExpectedSha256`
(`lib/features/azkar/data/azkar_supplementary_import.dart`), and
`azkarSupplementary2ExpectedSha256`
(`lib/features/azkar/data/azkar_supplementary_import_2.dart`).
