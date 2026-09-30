// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import 'font_credit.dart';

class AboutFontCreditsCard extends StatelessWidget {
  const AboutFontCreditsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('Typefaces'),
          const FontCredit(
            family: 'Inter',
            role: 'All UI text — titles, body, labels, settings, controls',
          ),
          const SizedBox(height: 12),
          const FontCredit(family: 'Amiri', role: 'Quran and Arabic text'),
          const SizedBox(height: 12),
          const FontCredit(family: 'Noto Sans Tamil', role: 'Tamil interface text'),
          const SizedBox(height: 12),
          const FontCredit(family: 'Noto Sans Sinhala', role: 'Sinhala interface text'),
          const SizedBox(height: 12),
          const FontCredit(
            family: 'Cormorant Garamond',
            role: 'Headings in the Mushaf theme only',
          ),
          const SizedBox(height: 8),
          Text(
            'Each is licensed under the SIL Open Font Licence 1.1 and '
            'bundled with the app for fully offline use.',
            style: AppTypography.caption(context.colors.sage),
          ),
        ],
      ),
    );
  }
}
