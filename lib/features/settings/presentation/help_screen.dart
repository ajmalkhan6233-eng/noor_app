// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Help / FAQ: plain-language answers, all offline and all from l10n.
// Answers describe what the app does; they contain no religious rulings.

import 'package:flutter/material.dart';

import '../../../core/constants/app_color_tokens.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/constants/app_typography.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.colors;
    final items = <(String, String)>[
      (l10n.helpQ1, l10n.helpA1),
      (l10n.helpQ2, l10n.helpA2),
      (l10n.helpQ3, l10n.helpA3),
      (l10n.helpQ4, l10n.helpA4),
      (l10n.helpQ5, l10n.helpA5),
      (l10n.helpQ6, l10n.helpA6),
      (l10n.helpQ7, l10n.helpA7),
      (l10n.helpQ8, l10n.helpA8),
      (l10n.helpQ9, l10n.helpA9),
    ];
    return Scaffold(
      backgroundColor: colors.paper,
      appBar: AppBar(title: Text(l10n.helpFaqLabel)),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) => AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  items[i].$1,
                  style: TextStyle(color: colors.ink, fontWeight: FontWeight.w600, fontSize: AppTypography.bodySize),
                ),
              ),
              const SizedBox(height: 8),
              Text(items[i].$2, style: TextStyle(color: colors.sage, height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
