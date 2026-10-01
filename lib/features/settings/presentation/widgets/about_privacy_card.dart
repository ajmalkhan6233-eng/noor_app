// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_info.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Version line plus the one-sentence privacy promise.
class AboutPrivacyCard extends StatelessWidget {
  const AboutPrivacyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(child: Icon(Icons.lock_outline, color: colors.gold, size: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.privacyStatement,
                  style: AppTypography.bodyStrong(colors.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.aboutVersion('$appVersionName ($appBuildNumber)'),
            style: AppTypography.caption(colors.sage),
          ),
        ],
      ),
    );
  }
}
