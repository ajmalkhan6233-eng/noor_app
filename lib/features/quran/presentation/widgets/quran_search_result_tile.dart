// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One search hit — same hairline-row shape as SurahListTile, not a
// bare Material ListTile.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/quran_ayah.dart';

class QuranSearchResultTile extends StatelessWidget {
  const QuranSearchResultTile({
    super.key,
    required this.ayah,
    required this.onTap,
  });

  final QuranAyah ayah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SemanticButton(
      label: l10n.searchResultSemanticLabel(ayah.surahId, ayah.ayahNumber),
      hint: l10n.openHint,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.colors.hairline)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ayah.arabicText,
              textDirection: TextDirection.rtl,
              style: AppTypography.arabic(context.colors.ink),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.surahAyahLabel(ayah.surahId, ayah.ayahNumber),
              style: AppTypography.caption(context.colors.sage),
            ),
          ],
        ),
      ),
    );
  }
}
