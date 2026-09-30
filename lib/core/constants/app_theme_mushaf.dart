// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Mushaf ThemeData: the shared buildAppTheme() (square corners and no
// shadows come from the tokens' `flatSurfaces`) plus Cormorant Garamond
// for headings only. Body stays Inter, Arabic stays Amiri (set
// explicitly by Quran/Azkar widgets, so never touched here).

import 'package:flutter/material.dart';

import 'app_color_tokens_mushaf.dart';
import 'app_theme.dart';

const String _headingFamily = 'Cormorant Garamond';

ThemeData buildMushafTheme() {
  final base = buildAppTheme(appColorTokensMushaf);
  final ink = appColorTokensMushaf.ink;
  TextStyle heading(double size) => TextStyle(
    fontFamily: _headingFamily,
    fontWeight: FontWeight.w700,
    fontSize: size,
    color: ink,
  );
  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      titleTextStyle: heading(24),
      shape: Border(bottom: BorderSide(color: appColorTokensMushaf.hairline)),
    ),
    textTheme: base.textTheme.copyWith(
      displayLarge: heading(40),
      displayMedium: heading(34),
      displaySmall: heading(30),
      headlineLarge: heading(28),
      headlineMedium: heading(26),
      headlineSmall: heading(24),
      titleLarge: heading(22),
      titleMedium: heading(18),
    ),
  );
}
