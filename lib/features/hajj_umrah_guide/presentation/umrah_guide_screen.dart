// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Read-only Umrah instructional guide: the eight steps in order, with
// the Talbiyah (step 3, sourced live) and the Ramal/Idtiba etiquette
// notes (step 4) attached, plus a suggested supplication (Qur'an
// 2:201, sourced live) after Sa'i. Every screen carries the persistent
// scholar-confirmation notice.

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/umrah_guide_steps.dart';
import 'widgets/guide_step_card.dart';
import 'widgets/rabbana_ayah_card.dart';
import 'widgets/scholar_notice_banner.dart';
import 'widgets/talbiyah_card.dart';
import 'widgets/tawaf_etiquette_note.dart';

class UmrahGuideScreen extends StatelessWidget {
  const UmrahGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = umrahGuideSteps(l10n);
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: Text(l10n.umrahGuideLabel)),
      body: Column(
        children: [
          const ScholarNoticeBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                StaggeredFadeIn(
                  children: [
                    for (var i = 0; i < steps.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i == steps.length - 1 ? 0 : 16,
                        ),
                        child: GuideStepCard(
                          step: steps[i],
                          trailing: _trailingFor(i),
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

  Widget? _trailingFor(int index) {
    return switch (index) {
      2 => const TalbiyahCard(),
      3 => const TawafEtiquetteNote(),
      6 => RabbanaAyahCard(),
      _ => null,
    };
  }
}
