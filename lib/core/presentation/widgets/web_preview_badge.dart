// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown only when running as a Flutter web build (the GitHub Pages
// visual-preview mirror built by .github/workflows/web-preview.yml) —
// never on the real Android APK. Sits next to BuildInfo's build stamp
// so a screenshot of the web preview can never be mistaken for the
// real app: compass, GPS, haptics, and the encrypted local database
// don't behave the same here.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../constants/app_color_tokens.dart';

class WebPreviewBadge extends StatelessWidget {
  const WebPreviewBadge({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.goldBorder,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.gold),
      ),
      child: Text(
        'WEB PREVIEW — not final build',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: context.colors.gold,
        ),
      ),
    );
  }
}
