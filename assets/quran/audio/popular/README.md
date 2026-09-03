# Quran recitation audio (curated additions) — provenance and licence

4 recordings, individually chosen — Al-Kahf (18), Ya-Sin (36),
Ar-Rahman (55), Al-Mulk (67) — commonly recited outside the daily-
prayer/Juz Amma set (Friday sunnah, before sleep, and general
frequently-recited surahs respectively). Bundled for offline playback
(no network fetch, per the app's offline-first rule), at the same
lowest bitrate as the Juz Amma set (32kbps) for consistency.

## Why these four, not more

Unlike Juz Amma (a contiguous, small block of short surahs), extending
coverage further into the full 114-surah collection would reintroduce
the same size problem Juz Amma's own README documents (~294MB for the
full set, more than 3x this app's size). These four were chosen
individually because they're specifically and commonly requested
outside Juz Amma, not as the start of a broader expansion — any future
addition should get the same individual justification, not be added
in bulk.

## Source

Same collection as Juz Amma — see `../juz_amma/README.md` for the full
provenance section (item, reciter, uploader, licence). Repeated here
for convenience:

**Item:** "Moeed Alharthi - Hafs | Dhikr Al-Huda" — Internet Archive
(`archive.org/details/dhikr-alhuda-moeed-alharthi-hafs`)
**Reciter:** Moeed Alharthi (معيض الحارثي), Hafs `an `Asim narration
**Licence:** Attribution 4.0 International (CC BY 4.0)
(`creativecommons.org/licenses/by/4.0/`) — permits commercial use,
modification, and redistribution, with attribution. Attribution for
this reciter is already shown on the app's About screen (shared with
the Juz Amma credit — same reciter, same source item).

Files taken from the collection's `murattal/32/` directory (32kbps
M4A), renamed to just the zero-padded surah number (e.g.
`murattal/32/018.m4a` -> `018.m4a`). No transcoding or editing
performed beyond that rename. Each file's `ftyp` header was checked to
confirm a valid M4A container, not a corrupted or HTML-error download.

## SHA-256

| File | SHA-256 |
| --- | --- |
| `018.m4a` | `668ae96395e51fad5968a8039b78fd33a664b68a175a846ff67746940920f7ac` |
| `036.m4a` | `db357009bf98d33cfe461a953a31551541acafe95cf746f9b83f74b071d0e9d2` |
| `055.m4a` | `b275bc18fc45f55f18323d5925eebfa41ed97fac95ef2e69bbe067831f21e220` |
| `067.m4a` | `a30a4b9542b96ce206f9e9a9034cba760b66115735739c8500b81ce4251ebc55` |

## Updating

If these files are ever replaced or the set expanded, update this
README's provenance and hash table — do not silently swap or add audio
without recording where it came from and under what licence, same rule
as the Adhan recordings and Juz Amma.
