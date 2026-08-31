// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The small circular ayah-number ornament that sits inline at the end
// of each ayah in the continuous-flow reader (2026-08-31 redesign —
// replaces one AppCard per ayah with real running Mushaf-style text).
// Doubles as the bookmark toggle and the reading-position anchor:
// tapping it bookmarks the ayah, and its GlobalKey is what
// ReadingPositionTracker watches to know which ayah is on screen —
// any keyed widget works for that, this one just happens to be small.

import 'package:flutter/material.dart';

import '../../../../core/utils/semantics_helpers.dart';
import '../../../../core/constants/app_color_tokens.dart';

class AyahEndMark extends StatelessWidget {
  const AyahEndMark({
    super.key,
    required this.ayahNumber,
    required this.isBookmarked,
    required this.onTap,
  });

  final int ayahNumber;
  final bool isBookmarked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SemanticButton(
      label: isBookmarked ? 'Ayah $ayahNumber, bookmarked' : 'Ayah $ayahNumber',
      hint: isBookmarked ? 'Double tap to remove bookmark' : 'Double tap to bookmark',
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isBookmarked ? colors.gold : Colors.transparent,
          border: Border.all(color: colors.gold, width: 1.2),
        ),
        child: Text(
          '$ayahNumber',
          style: TextStyle(
            color: isBookmarked ? colors.paper : colors.gold,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
