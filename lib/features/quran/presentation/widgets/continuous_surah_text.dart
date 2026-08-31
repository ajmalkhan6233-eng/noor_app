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

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../data/quran_ayah.dart';
import 'ayah_end_mark.dart';
import '../../../../core/constants/app_color_tokens.dart';

class ContinuousSurahText extends StatelessWidget {
  const ContinuousSurahText({
    super.key,
    required this.ayahs,
    required this.fontScale,
    required this.bookmarkedAyahNumbers,
    required this.onToggleBookmark,
    required this.ayahKeyFor,
  });

  final List<QuranAyah> ayahs;
  final double fontScale;
  final Set<int> bookmarkedAyahNumbers;
  final ValueChanged<int> onToggleBookmark;
  final GlobalKey Function(int ayahNumber) ayahKeyFor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyle = TextStyle(
      fontFamily: AppTypography.arabicFamily,
      color: colors.ink,
      fontSize: 22 * fontScale,
      height: 2.1,
    );
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: textStyle,
        children: [
          for (final ayah in ayahs) ...[
            TextSpan(text: '${ayah.arabicText} '),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: KeyedSubtree(
                key: ayahKeyFor(ayah.ayahNumber),
                child: AyahEndMark(
                  ayahNumber: ayah.ayahNumber,
                  isBookmarked: bookmarkedAyahNumbers.contains(ayah.ayahNumber),
                  onTap: () => onToggleBookmark(ayah.ayahNumber),
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
