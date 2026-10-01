// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Mushaf — a printed-Quran look: parchment paper, dark ink, deep green
// accents and thin gold rules. Light brightness, square corners, no
// shadows. Contrast (WCAG): ink 14.8:1 on paper, sage 6.4:1, green
// 7.0:1 (and paper-on-green button text 7.0:1); goldMuted is used only
// for large headings (4.2:1, needs 3:1). The gold rule colour is a
// decoration, never text.

import 'package:flutter/material.dart';

import 'app_color_tokens.dart';

const AppColorTokens appColorTokensMushaf = AppColorTokens(
  // Parchment.
  paper: Color(0xFFF6EDD9),
  // A shade darker than paper so cards read as slightly recessed.
  card: Color(0xFFEFE4CB),
  ink: Color(0xFF1F1A14),
  // Muted brown-grey secondary text.
  sage: Color(0xFF5E5448),
  // Thin 1px gold rules between/around content.
  hairline: Color(0xFFB89B3E),
  goldBorder: Color(0xFFB89B3E),
  // Deep green: the accent for buttons, icons and links.
  gold: Color(0xFF1E5A3C),
  // Darker gold for large screen titles and borders that need weight.
  goldMuted: Color(0xFF8A6D1F),
  accentSecondary: Color(0xFF1E5A3C),
  brightness: Brightness.light,
  cornerRadius: 2,
  flatSurfaces: true,
  headingFontFamily: 'Cormorant Garamond',
);
