# Quran translation text — provenance, license, and verification

This directory ships one file:

- `en-sahih.txt` — Saheeh International (translator credited on Tanzil
  as "Umm Muhammad") English translation, Tanzil `sura|aya|text`
  format, one ayah per line, matching the layout of
  `assets/quran/tanzil-uthmani.txt`.

`QuranImportService` (via `quran_translation_backfill.dart`)
SHA-256-verifies this file before backfilling it into the `translation`
column of already-imported `quran_ayahs` rows. If the checksum doesn't
match, the translation is silently skipped — the Arabic text keeps
working exactly as it does today; there is no path that displays
unverified translation text.

    en-sahih.txt   sha256: a98e1f2f7cdd728501c73750c6f3caf3fa3e80216b1520a1d7cd7ae8cec35d94

## Why this translation

Saheeh International is one of the most widely used English Quran
translations and, like the Arabic text already in this app, is
distributed by the Tanzil Project (tanzil.net) — the same trusted
provider, so the same provenance story applies.

## License — read this before adding another translation or changing use

**This is a materially different license than the Arabic text's.** The
Arabic text (`assets/quran/tanzil-uthmani.txt`) is Tanzil's own work,
licensed CC BY (attribution, verbatim-only). Tanzil does not hold
copyright on third-party translations — it hosts them with the
translator/publisher's permission, under Tanzil's own stated terms for
`https://tanzil.net/trans/`:

> "The translations provided at this page are for **non-commercial
> purposes only**. If used otherwise, you need to obtain necessary
> permission from the translator or the publisher."

`tanzil.net` itself was not reachable from the environment this file
was prepared in (network egress policy blocks it, same as for the
Arabic text — see `assets/quran/README.md`), so this exact wording
could not be re-confirmed by loading the page directly. It is recorded
here from an independent web search of the page's own text, cross-
checked against a second, structurally different signal: a GitHub
mirror of Tanzil's translation files (`q-ran/quran`) embeds a full
"TERMS OF USE" block for the Arabic text but only bare identifying
metadata (translator, language, source) for its bundled translations —
i.e. no CC grant at all on the translation text itself, consistent
with Tanzil not being the rights holder for translations and instead
gating their use via the non-commercial notice above.

**This app satisfies that condition today**: noor is free, ad-free,
has no in-app purchases or subscriptions, and its optional Donate
section is a voluntary, unconnected link to support development, not a
sale of the app or its content (see `pubspec.yaml`'s description and
`lib/features/settings/presentation/widgets/about_donate_section.dart`).
If noor is ever monetized (ads, paid tiers, etc.), this translation's
inclusion needs to be re-reviewed against that restriction — the
Arabic text's CC BY license would not need the same review, since it
allows commercial use.

## Where this came from

Bundled from two independent, separately-maintained sources, both
sourcing this same translation from `tanzil.net/trans/en.sahih`:

- `fawazahmed0/quran-api` (`editions/eng-ummmuhammad.json`, fetched via
  `raw.githubusercontent.com`) — used as the primary source for the
  shipped file.
- `risan/quran-json` (`data/editions/en.json`, fetched via
  `raw.githubusercontent.com`) — used as an independent cross-check;
  its README explicitly states "The English translation is authored by
  Umm Muhammad (Saheeh International), and it's sourced from
  tanzil.net" (linking `https://tanzil.net/trans/en.sahih`).

## Verification performed

1. **Cross-mirror diff.** All 6236 ayahs from both sources were
   compared text-for-text after normalising by (surah, ayah). Zero
   mismatches.
2. **Structural scan.** All 6236 lines checked programmatically for
   duplicate or missing (surah, ayah) keys and non-sequential
   numbering. Zero anomalies.
3. **Ayah/surah counts.** Every one of the 114 surahs' ayah counts in
   the shipped file matches the canonical values already verified for
   the Arabic text (Al-Fatiha 7, Al-Baqara 286, An-Nas 6, total 6236).

Given `tanzil.net` itself could not be reached, this is the same
strength of verification used for the Arabic text when it was in the
same position: two independently-hosted mirrors agreeing byte-for-byte,
plus full structural/count validation — not a checksum cross-check
against a value Tanzil publishes directly.

## Updating

    shasum -a 256 assets/quran_translations/en-sahih.txt

Set the result as `quranTranslationExpectedSha256` in
`lib/features/quran/data/quran_translation_backfill.dart`.
