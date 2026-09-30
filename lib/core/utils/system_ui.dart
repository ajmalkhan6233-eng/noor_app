// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Status-bar icons must contrast with the theme: light icons on the
/// dark themes (Nebula, Emerald Night), dark icons on Dawn and Mushaf.
SystemUiOverlayStyle overlayStyleFor(Brightness themeBrightness) {
  final base = themeBrightness == Brightness.dark
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;
  return base.copyWith(statusBarColor: Colors.transparent);
}
