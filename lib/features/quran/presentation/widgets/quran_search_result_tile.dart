// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One search hit — same hairline-row shape as SurahListTile, not a
// bare Material ListTile.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/semantics_helpers.dart';
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
    return SemanticButton(
      label: 'Search result: Surah ${ayah.surahId}, Ayah ${ayah.ayahNumber}',
      hint: 'Double tap to open',
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.hairline)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ayah.arabicText,
              textDirection: TextDirection.rtl,
              style: AppTypography.arabic,
            ),
            const SizedBox(height: 4),
            Text(
              'Surah ${ayah.surahId}, Ayah ${ayah.ayahNumber}',
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    );
  }
}
