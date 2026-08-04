# Quran source text — provenance and verification

This directory ships two files, both required for the Quran feature:

- `tanzil-uthmani.txt` — Tanzil "simple text (with aya numbers)" format,
  one ayah per line, `sura|aya|text`.
- `tanzil-quran-data.xml` — Tanzil's surah metadata: Arabic name,
  transliteration, English meaning, ayah count, and revelation place
  for all 114 surahs.

`QuranImportService` SHA-256-verifies both files against the constants
below before importing anything. If either checksum doesn't match, the
Quran feature is disabled and no text is shown — there is no path that
displays unverified text.

    tanzil-uthmani.txt      sha256: 8119475acf1ddd48a242f663dce7a21f0a8514e901bba136d4156805b766ece5
    tanzil-quran-data.xml   sha256: 8867c1d88191472adec9db694b3cd9f135b1a2ef580574d32cf888dcb22c5c7a

## Where this came from

The canonical source is the Tanzil Project (tanzil.net), which
publishes Quran text under Creative Commons Attribution 3.0/4.0 with
one condition: the text may be copied and distributed verbatim, but
**changing it is not allowed**.

`tanzil.net` was not reachable from the environment this import was
prepared in (network egress policy blocks it, HTTP 403). Instead, the
files here were sourced from two independent, separately-maintained
GitHub mirrors that each host a copy of Tanzil Quran Text (Uthmani,
version 1.0.2) with Tanzil's copyright block intact:

- Ayah text: `cchartm16/quran` (`quran-uthmani.txt`, fetched via
  `raw.githubusercontent.com`)
- Ayah text (cross-check) + surah metadata: `q-ran/quran`
  (`sources/1.0/quran-uthmani.xml`, `sources/1.0/quran-data.xml`)

## Verification performed

Both mirrors carry Tanzil's exact copyright/terms-of-use block
verbatim, and this repo's `tanzil-uthmani.txt` reproduces it at the
end of the file, per Tanzil's terms.

1. **Ayah/surah counts.** Every one of the 114 surahs' ayah counts
   matches the well-known canonical values (Al-Fatiha 7, Al-Baqara
   286, An-Nas 6, ..., total 6236) in both the text file and the
   metadata XML.
2. **Structural scan.** All 6236 lines checked programmatically for
   duplicate or missing (surah, ayah) keys, non-sequential numbering,
   stray whitespace, tabs, and any character outside the Arabic
   Unicode blocks (letters, diacritics, presentation forms). Zero
   anomalies found.
3. **Cross-mirror diff.** The two independently-hosted mirrors
   (`cchartm16/quran`'s plain text and `q-ran/quran`'s XML) were
   diffed ayah-by-ayah. All 6236 ayahs matched exactly, **except** the
   112 ayahs where the plain-text format embeds the Bismillah into
   ayah 1 (Tanzil's documented convention for every surah but
   At-Tawbah) — those all matched too, once that known, documented
   prefix is accounted for.
4. **One real discrepancy found and fixed.** The `cchartm16/quran`
   mirror's embedded Bismillah carried a spurious extra shadda
   (`بِّسْمِ` instead of `بِسْمِ`) in exactly 2 of 113 occurrences
   (Surahs 95 and 97) — a transcription error in that specific mirror,
   not present in the XML mirror or anywhere else in either file. The
   shipped `tanzil-uthmani.txt` was rebuilt programmatically from the
   XML mirror's ayah text (which does not have this error), using the
   Bismillah string extracted from Surah 1 Ayah 1 itself — never
   hand-typed — and prepending it to ayah 1 of every surah but
   At-Tawbah, matching Tanzil's own documented plain-text convention.
   No Arabic text in this repository was authored by hand; every
   character came from a downloaded, cross-checked source file.

Given `tanzil.net` itself could not be reached, this is the strongest
verification achievable in this environment: two independent mirrors
agreeing byte-for-byte (once formatting conventions are accounted for)
and full structural/count validation. It is **not** a checksum
cross-check against a value Tanzil publishes directly. If you have
direct access to tanzil.net, downloading the current release (Tanzil's
latest is 1.1; this ships 1.0.2) and replacing these files — updating
the SHA-256 constants in `QuranImportService` to match — is
recommended.

## Updating

    shasum -a 256 assets/quran/tanzil-uthmani.txt
    shasum -a 256 assets/quran/tanzil-quran-data.xml

Set the results as `QuranImportService.expectedSha256` and
`expectedMetadataSha256` respectively
(`lib/features/quran/data/quran_import_service.dart`).
