// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/zakat_calculator.dart';

class ZakatResultCard extends StatelessWidget {
  const ZakatResultCard({super.key, required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final nisabLabel = result.nisabThreshold == 0
        ? l10n.nisabPromptMessage
        : l10n.nisabThresholdMessage(
            result.nisabThreshold.toStringAsFixed(2),
            result.nisabMet ? l10n.nisabMetLabel : l10n.nisabNotMetLabel,
          );

    return Semantics(
      label: l10n.zakatSummarySemanticLabel(
        result.netWealth.toStringAsFixed(2),
        nisabLabel,
        result.zakatDue.toStringAsFixed(2),
      ),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.netWealthLabel, style: AppTypography.caption),
            const SizedBox(height: 4),
            Text(
              result.netWealth.toStringAsFixed(2),
              style: const TextStyle(color: AppColors.ink, fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(nisabLabel, style: AppTypography.caption),
            const SizedBox(height: 16),
            const Divider(color: AppColors.hairline, height: 1),
            const SizedBox(height: 16),
            Text(l10n.zakatDueLabel, style: AppTypography.caption),
            const SizedBox(height: 4),
            Text(
              result.zakatDue.toStringAsFixed(2),
              style: AppTypography.heroDisplay.copyWith(
                fontSize: 36,
                color: result.nisabMet ? AppColors.gold : AppColors.sage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
