// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One instructional step/day card. Plain text, no interaction, so it
// only needs to be reachable by a screen reader in document order —
// no Semantics() wrapper is required for a non-interactive card.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/guide_step.dart';

class GuideStepCard extends StatelessWidget {
  const GuideStepCard({super.key, required this.step, this.trailing});

  final GuideStep step;

  /// Optional extra content shown below the body text, e.g. the
  /// Talbiyah card on the Umrah Talbiyah step, or the Idtiba/Ramal
  /// reminders on the Tawaf step.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isEnglish = Localizations.localeOf(context).languageCode == 'en';
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(step.body, style: const TextStyle(color: AppColors.sage, height: 1.4)),
          if (!isEnglish) ...[
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context)!.guideBodyEnglishOnlyNote,
              style: const TextStyle(
                color: AppColors.sage,
                fontStyle: FontStyle.italic,
                fontSize: 11,
              ),
            ),
          ],
          if (trailing != null) ...[const SizedBox(height: 12), trailing!],
        ],
      ),
    );
  }
}
