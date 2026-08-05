# Azkar source data — provenance and licence

Three files:

- `adhkar-ar.json` — Arabic text, per-item source citation (morning/evening).
- `adhkar-en.json` — English translation, transliteration, and the
  same per-item source citation (morning/evening).
- `hisn-supplementary.json` — Arabic text and source citation for
  after_prayer, sleep, and travel (added later — see its own section
  below; no English translation available for these).

`AzkarImportService` SHA-256-verifies the first two before importing,
and separately (via `azkar_supplementary_import.dart`)
SHA-256-verifies the third before backfilling it.

    adhkar-ar.json           sha256: 9e0dd6a10d26ddc0e2b36b94098c287644996c7f81b707f8ad24f1ce40b8c821
    adhkar-en.json           sha256: eec053c4138bed6f3ec7dc3c0e06e926a935dca24663788e5b97a0bfb5f71896
    hisn-supplementary.json  sha256: 0f683306e391af8a80c09457a620bd29ef56b7e5c973ebf4339bc30321b335c3

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
than these three; only the three the app's schema is scoped for were
extracted, to avoid pulling in content the UI has no category for yet.

## Coverage

`morning`/`evening`: 34 items (16 marked for both, 10 morning-only, 8
evening-only), English translation included. `after_prayer`: 8 items.
`sleep`: 15 items. `travel`: 1 item. All five of the app's azkar
categories are now populated — none remain genuinely unsourced.

## Updating

    shasum -a 256 assets/azkar/adhkar-ar.json
    shasum -a 256 assets/azkar/adhkar-en.json
    shasum -a 256 assets/azkar/hisn-supplementary.json

Set the results as `AzkarImportService.expectedArSha256` /
`expectedEnSha256` (`lib/features/azkar/data/azkar_import_service.dart`)
and `azkarSupplementaryExpectedSha256`
(`lib/features/azkar/data/azkar_supplementary_import.dart`).
