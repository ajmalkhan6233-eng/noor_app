// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/corner_radius.dart';
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
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.colors.card,
          borderRadius: BorderRadius.circular(context.radiusFor(12)),
          border: Border.all(
            color: context.colors.goldBorder.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 32,
              child: Center(
                child: Text(
                  '${surah.id}',
                  style: AppTypography.body(context.colors.gold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.displayName,
                    style: AppTypography.bodyStrong(context.colors.ink),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.caption(context.colors.sage),
                    ),
                  ],
                ],
              ),
            ),
            if (surah.nameArabic != null) ...[
              const SizedBox(width: 8),
              Text(
                surah.nameArabic!,
                textDirection: TextDirection.rtl,
                style: AppTypography.arabic(context.colors.ink).copyWith(
                  fontSize: AppTypography.arabicSmallSize,
                  height: 1.2,
                ),
              ),
            ],
            const SizedBox(width: 12),
            Text(
              '${surah.ayahCount}',
              style: AppTypography.body(context.colors.sage),
            ),
          ],
        ),
      ),
    );
  }
}
