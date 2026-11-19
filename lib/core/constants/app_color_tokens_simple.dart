// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The default "Simple" look (2026-11-19, Aj's decision): plain, light
// and system-like, in the spirit of the iPhone phone app. Flat cards,
// no glow. The rich Cosmic/Dawn/Mushaf/Emerald looks stay available
// behind Settings > Display > Rich visuals.

import 'package:flutter/material.dart';

import 'app_color_tokens.dart';

const AppColorTokens appColorTokensSimpleLight = AppColorTokens(
  paper: Color(0xFFF2F2F7),
  card: Color(0xFFFFFFFF),
  ink: Color(0xFF1C1C1E),
  sage: Color(0xFF6C6C70),
  hairline: Color(0xFFD1D1D6),
  goldBorder: Color(0xFFD1D1D6),
  gold: Color(0xFF007AFF),
  goldMuted: Color(0xFF5E9EFF),
  accentSecondary: Color(0xFF34C759),
  brightness: Brightness.light,
  cornerRadius: 12,
  flatSurfaces: true,
);

const AppColorTokens appColorTokensSimpleDark = AppColorTokens(
  paper: Color(0xFF000000),
  card: Color(0xFF1C1C1E),
  ink: Color(0xFFFFFFFF),
  sage: Color(0xFF8E8E93),
  hairline: Color(0xFF38383A),
  goldBorder: Color(0xFF38383A),
  gold: Color(0xFF0A84FF),
  goldMuted: Color(0xFF64A8FF),
  accentSecondary: Color(0xFF30D158),
  brightness: Brightness.dark,
  cornerRadius: 12,
  flatSurfaces: true,
);
