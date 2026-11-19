// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Renders a whole surah's ayahs as one continuous running paragraph —
// verses flowing together the way they do on an actual Mushaf page,
// each ending in a small circled ayah-number ornament (AyahEndMark)
// instead of the previous one-AppCard-per-ayah list. Arabic only, per
// the same standing decision AyahTile documented (translation never
// shows on a reading screen, only in search results).
//
// Real fixed 604-page Mushaf pagination was asked for alongside this,
// but isn't built: it needs a verified ayah-to-page mapping this
// project doesn't have a source for yet (the bundled Tanzil files
// carry surah/ayah only, no page boundaries) — continuous flowing
// text within a surah ships now; page-turn navigation is a separate,
// data-gated follow-up, not silently approximated with invented
// page breaks.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../data/quran_ayah.dart';
import 'ayah_end_mark.dart';
import '../../../../core/constants/app_color_tokens.dart';

class ContinuousSurahText extends StatefulWidget {
  const ContinuousSurahText({
    super.key,
    required this.ayahs,
    required this.fontScale,
    required this.bookmarkedAyahNumbers,
    required this.onToggleBookmark,
    required this.ayahKeyFor,
    this.onPlayAyah,
  });

  final List<QuranAyah> ayahs;
  final double fontScale;
  final Set<int> bookmarkedAyahNumbers;
  final ValueChanged<int> onToggleBookmark;
  final GlobalKey Function(int ayahNumber) ayahKeyFor;

  /// Tap on an ayah's text plays the recitation from that ayah
  /// (2026-11-19). Null = no timings for this surah: text isn't tappable.
  /// The ayah-number mark keeps toggling the bookmark.
  final ValueChanged<int>? onPlayAyah;

  @override
  State<ContinuousSurahText> createState() => _ContinuousSurahTextState();
}

class _ContinuousSurahTextState extends State<ContinuousSurahText> {
  final _recognizers = <int, TapGestureRecognizer>{};

  TapGestureRecognizer? _recognizerFor(int ayahNumber) {
    final onPlay = widget.onPlayAyah;
    if (onPlay == null) return null;
    final recognizer = _recognizers.putIfAbsent(ayahNumber, TapGestureRecognizer.new);
    recognizer.onTap = () => onPlay(ayahNumber);
    return recognizer;
  }

  @override
  void dispose() {
    for (final r in _recognizers.values) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyle = TextStyle(
      fontFamily: AppTypography.arabicFamily,
      color: colors.ink,
      fontSize: AppTypography.quranSize * widget.fontScale,
      height: AppTypography.quranHeight,
    );
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: textStyle,
        children: [
          for (final ayah in widget.ayahs) ...[
            TextSpan(
              text: '${ayah.arabicText} ',
              recognizer: _recognizerFor(ayah.ayahNumber),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: KeyedSubtree(
                key: widget.ayahKeyFor(ayah.ayahNumber),
                child: AyahEndMark(
                  ayahNumber: ayah.ayahNumber,
                  isBookmarked: widget.bookmarkedAyahNumbers.contains(ayah.ayahNumber),
                  onTap: () => widget.onToggleBookmark(ayah.ayahNumber),
                ),
              ),
            ),
            const TextSpan(text: '   '),
          ],
        ],
      ),
    );
  }
}
