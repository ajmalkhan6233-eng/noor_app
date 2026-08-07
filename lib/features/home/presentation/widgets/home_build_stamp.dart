// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of home_overview_screen.dart to keep it under the
// project's line-count convention. See CLAUDE.md rule 4 — this must
// stay visible on Home; test/widget_test.dart asserts on it.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/build_info.dart';
import '../../../../core/presentation/widgets/web_preview_badge.dart';

class HomeBuildStamp extends StatelessWidget {
  const HomeBuildStamp({super.key});

  @override
  Widget build(BuildContext context) {
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
