// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Attribution lines for bundled adhan recordings (see
// assets/audio/adhan/README.md for the full provenance). CC BY 3.0/4.0
// make the credit a licence condition, so every CC BY file listed
// there must appear here and in the About screen. If an adhan file is
// added, replaced or removed, update this list and the README together.

/// One credit line shown on the About screen.
class AudioCredit {
  const AudioCredit(this.file, this.line);

  /// Asset file name under assets/audio/adhan/.
  final String file;

  /// Text shown to the user.
  final String line;
}

const List<AudioCredit> adhanCredits = [
  AudioCredit(
    'indonesia.mp3',
    'Adhan (Indonesia): "Adhan-Call to Prayer Selection, Indonesia" by '
        'RTB45 (freesound.org/s/257821), CC BY 4.0. Shortened and '
        're-encoded.',
  ),
  AudioCredit(
    'aroumd.mp3',
    'Adhan (Aroumd, Morocco): "Adhan (call to prayer), Aroumd, Morocco" '
        'by iainmccurdy (freesound.org/s/807484), CC BY 4.0. Re-encoded.',
  ),
  AudioCredit(
    'hamtramck.mp3',
    'Adhan (Hamtramck): "Islamic Call to Prayer (Dhuhr Adhan), '
        'Hamtramck, MI" by RJStefanski (freesound.org/s/255231), '
        'CC BY 3.0. Re-encoded.',
  ),
  AudioCredit(
    'marrakech.mp3',
    'Adhan (Marrakech): "Call Of Prayer - ADHAN - Marrakech" by '
        'Redalemage (freesound.org/s/583206), CC0.',
  ),
  AudioCredit(
    'fajr.mp3',
    'Adhan (Doha): field recordings from Doha, Qatar, Public Domain '
        'Mark 1.0 (archive.org/details/adhan.recordings.from.doha.qatar).',
  ),
];
