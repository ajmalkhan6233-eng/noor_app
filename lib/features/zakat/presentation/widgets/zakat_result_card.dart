// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../data/zakat_calculator.dart';

class ZakatResultCard extends StatelessWidget {
  const ZakatResultCard({super.key, required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    final nisabLabel = result.nisabThreshold == 0
        ? 'Enter a gold or silver price to see the nisab threshold.'
        : 'Nisab threshold: ${result.nisabThreshold.toStringAsFixed(2)} — '
              '${result.nisabMet ? "met" : "not yet met"}.';

    return Semantics(
      label:
          'Net wealth ${result.netWealth.toStringAsFixed(2)}. $nisabLabel '
          'Zakat due: ${result.zakatDue.toStringAsFixed(2)}.',
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Net wealth', style: AppTypography.caption),
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
            const Text('Zakat due (2.5%)', style: AppTypography.caption),
            const SizedBox(height: 4),
            Text(
              result.zakatDue.toStringAsFixed(2),
              style: AppTypography.heroDisplay.copyWith(
                fontSize: 36,
                color: result.nisabMet ? AppColors.emerald : AppColors.sage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
