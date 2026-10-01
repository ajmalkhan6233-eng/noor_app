// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Mushaf ThemeData: the shared buildAppTheme() (square corners and no
// shadows come from the tokens' `flatSurfaces`) plus Cormorant Garamond
// for headings only. Body stays Inter, Arabic stays Amiri (set
// explicitly by Quran/Azkar widgets, so never touched here).

import 'package:flutter/material.dart';

import 'app_color_tokens_mushaf.dart';
import 'app_theme.dart';

/// Mushaf = the shared theme with square, flat surfaces (tokens) and
/// Cormorant Garamond for screen titles and section headings only, at
/// the same sizes as every other theme (tokens.headingFontFamily). Body
/// stays Inter; Arabic stays Amiri.
ThemeData buildMushafTheme() {
  final base = buildAppTheme(appColorTokensMushaf);
  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      shape: Border(bottom: BorderSide(color: appColorTokensMushaf.hairline)),
    ),
  );
}
