// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Read-only Hajj instructional guide, day by day (8th-13th Dhul
// Hijjah). The 10th's Tawaf al-Ifadah/Sa'i carries the same
// Ramal/Idtiba etiquette note as the Umrah guide, kept in sync via
// the shared localisation strings. Every screen carries the
// persistent scholar-confirmation notice.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/hajj_guide_days.dart';
import 'widgets/guide_step_card.dart';
import 'widgets/scholar_notice_banner.dart';
import 'widgets/tawaf_etiquette_note.dart';

class HajjGuideScreen extends StatelessWidget {
  const HajjGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(l10n.hajjGuideLabel)),
      body: Column(
        children: [
          const ScholarNoticeBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                StaggeredFadeIn(
                  children: [
                    for (var i = 0; i < hajjGuideDays.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == hajjGuideDays.length - 1 ? 0 : 16,
                        ),
                        // The 10th (index 2) includes Tawaf al-Ifadah/Sa'i.
                        child: GuideStepCard(
                          step: hajjGuideDays[i],
                          trailing: i == 2 ? const TawafEtiquetteNote() : null,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
