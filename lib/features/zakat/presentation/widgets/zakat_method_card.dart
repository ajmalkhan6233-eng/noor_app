// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Nisab basis choice + the rules note (2026-11-19). The app does not
// pick a madhab position silently: the person sees the choice and is
// pointed to a scholar.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/zakat_calculator.dart';

class ZakatMethodCard extends StatelessWidget {
  const ZakatMethodCard({super.key, required this.basis, required this.onChanged});

  final NisabBasis basis;
  final ValueChanged<NisabBasis> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.zakatNisabBasisLabel, style: AppTypography.caption(context.colors.sage)),
          const SizedBox(height: 8),
          Semantics(
            label: l10n.zakatNisabBasisLabel,
            child: SegmentedButton<NisabBasis>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: NisabBasis.lowest, label: Text(l10n.zakatNisabBasisLowest)),
                ButtonSegment(value: NisabBasis.gold, label: Text(l10n.zakatNisabBasisGold)),
                ButtonSegment(value: NisabBasis.silver, label: Text(l10n.zakatNisabBasisSilver)),
              ],
              selected: {basis},
              onSelectionChanged: (selection) => onChanged(selection.first),
            ),
          ),
          const SizedBox(height: 12),
          Text(l10n.zakatRulesNote, style: AppTypography.caption(context.colors.sage)),
        ],
      ),
    );
  }
}
