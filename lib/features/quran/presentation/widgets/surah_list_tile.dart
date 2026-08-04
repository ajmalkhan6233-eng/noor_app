// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/quran_surah.dart';

class SurahListTile extends StatelessWidget {
  const SurahListTile({super.key, required this.surah, required this.onTap});

  final QuranSurah surah;
  final VoidCallback onTap;

  String get _placeLabel => switch (surah.revelationPlace) {
    RevelationPlace.meccan => 'Meccan',
    RevelationPlace.medinan => 'Medinan',
    null => '',
  };

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (surah.nameEnglish != null) surah.nameEnglish!,
      if (_placeLabel.isNotEmpty) _placeLabel,
    ].join(' · ');

    return SemanticButton(
      label: '${surah.displayName}, ${surah.ayahCount} ayahs'
          '${subtitle.isNotEmpty ? ', $subtitle' : ''}',
      hint: 'Double tap to open',
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.hairline)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '${surah.id}',
                style: const TextStyle(color: AppColors.sage),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.displayName,
                    style: const TextStyle(color: AppColors.parchment),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.caption),
                  ],
                ],
              ),
            ),
            if (surah.nameArabic != null) ...[
              const SizedBox(width: 8),
              Text(
                surah.nameArabic!,
                textDirection: TextDirection.rtl,
                style: AppTypography.arabic.copyWith(fontSize: 18, height: 1.2),
              ),
            ],
            const SizedBox(width: 12),
            Text(
              '${surah.ayahCount}',
              style: const TextStyle(color: AppColors.sage),
            ),
          ],
        ),
      ),
    );
  }
}
