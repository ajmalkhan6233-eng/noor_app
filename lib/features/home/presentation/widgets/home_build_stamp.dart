// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of home_overview_screen.dart to keep it under the
// project's line-count convention. See CLAUDE.md rule 4 — this must
// stay visible on Home *in debug builds*; test/widget_test.dart
// asserts on it (flutter_test runs in debug mode, so the assertion
// still holds). Hidden in release builds — a real end user downloading
// the shipped app from the Play Store should never see a raw commit
// hash, only whoever is checking which build is actually installed
// during development/testing.

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/build_info.dart';
import '../../../../core/presentation/widgets/web_preview_badge.dart';

class HomeBuildStamp extends StatelessWidget {
  const HomeBuildStamp({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();
    return Center(
      child: Column(
        children: [
          const WebPreviewBadge(),
          Semantics(
            label: BuildInfo.label,
            child: const Text(BuildInfo.label, style: AppTypography.caption),
          ),
        ],
      ),
    );
  }
}
