// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../data/quran_ayah.dart';
import '../../../../core/constants/app_color_tokens.dart';

/// One ayah with its number and a bookmark toggle. Arabic and
/// translation text size both follow [fontScale] from Settings
/// (2026-08-25 audit: "translation text size can't be adjusted,
/// only Arabic" — same slider now covers both, translation scaling
/// off a smaller base so it doesn't dominate the Arabic line).
class AyahTile extends StatelessWidget {
  const AyahTile({
    super.key,
    required this.ayah,
    required this.fontScale,
    required this.isBookmarked,
    required this.onToggleBookmark,
  });

  final QuranAyah ayah;
  final double fontScale;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ayah ${ayah.ayahNumber}',
                  style: TextStyle(color: context.colors.sage),
                ),
                SemanticButton(
                  label: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
                  onTap: onToggleBookmark,
                  child: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: context.colors.gold,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ayah.arabicText,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: AppTypography.arabicFamily,
                color: context.colors.ink,
                fontSize: 22 * fontScale,
                height: 1.8,
              ),
            ),
            if (ayah.translation != null) ...[
              const SizedBox(height: 8),
              Text(
                ayah.translation!,
                style: TextStyle(color: context.colors.sage, fontSize: 14 * fontScale),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
