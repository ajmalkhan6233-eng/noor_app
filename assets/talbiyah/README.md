# Talbiyah source data — provenance and licence

One file: `talbiyah-ar.json` — the Talbiyah's Arabic text, its hadith
citation, and the chapter title it was taken from.

`TalbiyahRepository` SHA-256-verifies this file before displaying
anything from it.

    talbiyah-ar.json   sha256: 21a4772a5ff8fc5238978239e2f379cf41f298331a83ee46d107b79adfd431e2

## Source

**Repository:** `asellam/HisnElMuslim` (GitHub)
**File:** `hisn.json`, entry titled "كَيْفَ يُلَبِّي المُحْرِمُ فِي
الحَجِّ أَوْ العُمْرَةِ" ("How the muhrim recites the Talbiyah in Hajj
or Umrah").
**Licence:** MIT — verified by fetching the repo's `LICENSE.md` file
directly (copyright Abdellah SELLAM, 2021); MIT permits redistribution
and modification, which is why this dataset was chosen.

The underlying text is drawn by that project from *Hisn al-Muslim* by
Said bin Ali bin Wahf Al-Qahthani — the same base work already used
for `assets/azkar/`, cross-checked there against Hisn Al-Muslim and
Sunnah.com. This entry carries its own hadith reference (Bukhari,
*Fath al-Bari* 3/408, and Muslim 2/841), copied verbatim into the
`reference` field and shown in the UI, per the dataset's own sourcing
and this app's `.clinerules` requirement that no religious text ship
without attribution.

No Arabic text in this file was hand-typed by the assistant that
prepared this commit — it was downloaded programmatically from the
mirror above and used unmodified.

## Coverage

Only the Talbiyah is included. No confirmed openly-licensed source was
found for a Tamil or Sinhala translation of this text; the app shows
its normal "not loaded yet" message for those languages rather than
being padded with translated or invented text.

## Updating

    shasum -a 256 assets/talbiyah/talbiyah-ar.json

Set the result as `TalbiyahRepository.expectedSha256`
(`lib/features/hajj_umrah_guide/data/talbiyah_repository.dart`).
