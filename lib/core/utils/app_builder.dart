// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'system_ui.dart';
import 'text_scale.dart';

/// MaterialApp.builder: status-bar icons follow the theme, and body text
/// gets the app-wide boost (2026-08-26: text read too small on a real
/// device; most widgets set explicit font sizes, so one MediaQuery-level
/// bump reaches every screen) composed on top of the OS text scale.
Widget noorAppBuilder(BuildContext context, Widget? child) {
  final mediaQuery = MediaQuery.of(context);
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: overlayStyleFor(Theme.of(context).brightness),
    child: MediaQuery(
      data: mediaQuery.copyWith(textScaler: boostedTextScaler(mediaQuery.textScaler)),
      child: child!,
    ),
  );
}
