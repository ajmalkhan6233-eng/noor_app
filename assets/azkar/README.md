# Azkar source data — provenance and licence

Two files, both required for the Azkar feature:

- `adhkar-ar.json` — Arabic text, per-item source citation.
- `adhkar-en.json` — English translation, transliteration, and the
  same per-item source citation.

`AzkarImportService` SHA-256-verifies both before importing.

    adhkar-ar.json   sha256: 9e0dd6a10d26ddc0e2b36b94098c287644996c7f81b707f8ad24f1ce40b8c821
    adhkar-en.json   sha256: eec053c4138bed6f3ec7dc3c0e06e926a935dca24663788e5b97a0bfb5f71896

## Source

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

## Coverage

The dataset covers 34 items across `morning` and `evening` (16 marked
for both, 10 morning-only, 8 evening-only). It does not cover
`after_prayer`, `sleep`, or `travel` — those three categories remain
empty until a suitably-licensed source is found for them, and show the
app's normal "not loaded yet" empty state rather than being padded
with placeholder or invented text.

## Updating

    shasum -a 256 assets/azkar/adhkar-ar.json
    shasum -a 256 assets/azkar/adhkar-en.json

Set the results as `AzkarImportService.expectedArSha256` /
`expectedEnSha256` (`lib/features/azkar/data/azkar_import_service.dart`).
