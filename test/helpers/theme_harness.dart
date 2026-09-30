// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shared by the "every screen in every theme" widget tests.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:noor/core/constants/app_theme.dart';
import 'package:noor/core/constants/app_theme_emerald.dart';
import 'package:noor/core/constants/app_theme_mushaf.dart';
import 'package:noor/l10n/generated/app_localizations.dart';

/// Nebula, Dawn, Emerald Night, Mushaf — in the order of the picker.
Map<String, ThemeData Function()> get allThemes => {
  'Nebula': buildDarkTheme,
  'Dawn': buildLightTheme,
  'Emerald Night': buildEmeraldTheme,
  'Mushaf': buildMushafTheme,
};

Widget themedApp(Widget home, ThemeData theme, {double textScale = 1.0, Locale? locale}) {
  return MaterialApp(
    theme: theme,
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: home,
  );
}
