// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Debug-only build identity stamp — moved off Home (2026-08-24
// live-device review: a raw "Build dev · #0" line was visible on the
// main screen every real user sees, which reads as unfinished/leaked
// debug UI). Still needed for verifying which commit an installed
// APK actually contains during development, so it lives on About
// instead — reachable, but not thrust in front of every user on the
// screen they open most. Hidden entirely in release builds.

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import '../../constants/app_typography.dart';
import '../../constants/build_info.dart';
import 'web_preview_badge.dart';
import '../../../core/constants/app_color_tokens.dart';

class BuildStampFooter extends StatelessWidget {
  const BuildStampFooter({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();
    return Center(
      child: Column(
        children: [
          const WebPreviewBadge(),
          Semantics(
            label: BuildInfo.label,
            child: Text(BuildInfo.label, style: AppTypography.caption(context.colors.sage)),
          ),
        ],
      ),
    );
  }
}
