# Adhan audio — provenance and licence

Five recordings of the Islamic call to prayer, one per daily prayer,
bundled for offline playback (no network fetch, per the app's
offline-first rule).

    fajr.mp3
    dhuhr.mp3
    asr.mp3
    maghrib.mp3
    isha.mp3

## Source

**Collection:** "Adhan Recordings from Doha, Qatar" — Internet Archive
(`archive.org/details/adhan.recordings.from.doha.qatar`)
**Uploaded by:** abd.al.rahman@hushmail.com, 2015-12-22
**Recorded:** Doha, Qatar, 2013–2014 (uploader's own field recordings)
**Licence:** Public Domain Mark 1.0
(`creativecommons.org/publicdomain/mark/1.0/`) — explicitly permits
commercial use, modification, and redistribution without attribution.

Original filenames (renamed here to match this app's five prayer
keys):

- `Adhan_Doha_Qatar_01_Fajr_Adhan.mp3` -> `fajr.mp3`
- `Adhan_Doha_Qatar_02_Dhuhr_Adhan.mp3` -> `dhuhr.mp3`
- `Adhan_Doha_Qatar_03_Asr_Adhan.mp3` -> `asr.mp3`
- `Adhan_Doha_Qatar_04_Maghrib_Adhan.mp3` -> `maghrib.mp3`
- `Adhan_Doha_Qatar_05_Isha_Adhan.mp3` -> `isha.mp3`

No other transcoding or editing was performed.

## Licence caveat (read before adding any more reciters)

This is an individual uploader's self-declared Public Domain Mark on
their own field recordings of a public call to prayer — not a formally
licensed reciter release or a commercial audio API with written
commercial terms. Two other candidates were evaluated and rejected:

- A Freesound.org upload labelled CC0 was rejected: its own
  description states it was "extracted from a YouTube video and
  processed" — the uploader almost certainly didn't hold the rights to
  relicense someone else's recording as CC0.
- No Islamic audio API found during evaluation published explicit,
  written commercial-use terms that could be verified without direct
  provider contact.

If a firmer source (a named reciter's direct release, or an API with
explicit written commercial terms) becomes available later, prefer it
over this one and update this file accordingly.

## Alternate reciters (added 2026-08-28)

Four more selectable options, per direct request — this reverses the
2026-08-23 "ship with the one default reciter only" call above; noted
here for the record, not silently overridden. Unlike the five Doha
files, each of these is ONE recording used for every prayer (none of
the sources are split by prayer name). All fetched from Freesound.org's
public preview CDN (`cdn.freesound.org/previews/...`), which serves a
lossy re-encode of the original upload — licence terms below are
independently verified against each sound's own Freesound page, not
inferred from the preview.

- `indonesia.mp3` — trimmed from "Adhan-Call to Prayer Selection,
  Indonesia" by RTB45 (`freesound.org/s/257821`). The original is a
  12:33 concatenation of six different Indonesian city recordings; a
  silence gap at ~3:15 marks the boundary of the first (the file is
  trimmed to just that segment, ~3s–195s, with a short fade). **Which
  specific city this segment is has not been independently confirmed**
  — the upload only lists six cities for the whole file, not per
  segment. CC BY 4.0 — attribution required, shown in Settings.
- `marrakech.mp3` — "Call Of Prayer - ADHAN - Marrakech.WAV" by
  Redalemage (`freesound.org/s/583206`), recorded from a café terrace
  at Jemaa El-Fna square during Maghrib. Full length. CC0 — no
  attribution legally required, but credited anyway for transparency.
- `aroumd.mp3` — "Adhan (call to prayer), Aroumd, Morocco" by
  iainmccurdy (`freesound.org/s/807484`), recorded near a mosque in
  the Atlas mountains (Mizane valley), a nearby river audible in the
  background. Full length. CC BY 4.0 — attribution required.
- `hamtramck.mp3` — "Islamic Call to Prayer (Dhuhr Adhan), Hamtramck,
  MI" by RJStefanski (`freesound.org/s/255231`). Full length. CC BY
  3.0 — attribution required. **Flagged, not resolved**: this is a
  real muezzin recorded at a real mosque without that person's direct
  consent to being repurposed as app notification audio — the licence
  chain (RJStefanski's own recording copyright) is genuinely clean,
  but a prior session (2026-08-27) passed on this exact file for that
  content-appropriateness reason, independent of licensing. Included
  now because it was explicitly re-requested (2026-08-28) — flagging
  again rather than silently dropping the concern.

All four re-encoded (mono, 44.1kHz, 96kbps MP3, short fade-out) to
match this folder's existing size convention — originals were 20-127MB
uncompressed WAV field recordings, not usable as-is for a mobile app
asset.

## Updating

If these files are ever replaced, update this README's provenance
section to match — do not silently swap audio without recording where
it came from and under what licence.
