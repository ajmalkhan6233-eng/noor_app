// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/quran_surah.dart';

class SurahListTile extends StatelessWidget {
  const SurahListTile({super.key, required this.surah, required this.onTap});

  final QuranSurah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: '${surah.displayName}, ${surah.ayahCount} ayahs',
      hint: 'Double tap to open',
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${surah.id}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  surah.displayName,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
            Text(
              '${surah.ayahCount} ayahs',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
