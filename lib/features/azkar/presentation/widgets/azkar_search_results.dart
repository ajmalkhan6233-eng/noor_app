// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/azkar_category.dart';
import '../../data/azkar_item.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';

class AzkarSearchResults extends StatelessWidget {
  const AzkarSearchResults({
    super.key,
    required this.results,
    required this.controller,
    required this.onSelectCategory,
  });

  final List<(AzkarCategory category, AzkarItem item)> results;
  final ScrollController controller;
  final void Function(BuildContext context, AzkarCategory category) onSelectCategory;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.azkarNoMatches, style: AppTypography.body(context.colors.sage)),
      );
    }
    return ListView.separated(
      controller: controller,
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final (category, item) = results[index];
        final resultLabel = item.transliteration ?? item.translation ?? '';
        return AppCard(
          padding: EdgeInsets.zero,
          child: SemanticButton(
            label: '${category.label}: $resultLabel',
            hint: 'Double tap to open this dua',
            onTap: () => onSelectCategory(context, category),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.label, style: TextStyle(color: context.colors.gold, fontSize: AppTypography.captionSize)),
                  const SizedBox(height: 4),
                  Text(
                    resultLabel,
                    style: AppTypography.body(context.colors.ink),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
