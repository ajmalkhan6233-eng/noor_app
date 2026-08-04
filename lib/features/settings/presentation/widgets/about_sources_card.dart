// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Tanzil's terms of use require the source to be clearly indicated
// and a link made to tanzil.net — this card is that attribution.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';

class AboutSourcesCard extends StatelessWidget {
  const AboutSourcesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('Text sources'),
          const Text(
            'Quran text: Tanzil Quran Text (Uthmani, version 1.0.2), '
            'Copyright © Tanzil.net, licensed under Creative Commons '
            'Attribution 3.0. Unmodified verbatim copy; see '
            'assets/quran/README.md for full provenance and '
            'verification details.',
            style: AppTypography.caption,
          ),
          const SizedBox(height: 8),
          SemanticButton(
            label: 'Copy tanzil.net link',
            hint: 'Double tap to copy the Tanzil Project web address',
            onTap: () async {
              await Clipboard.setData(
                const ClipboardData(text: 'https://tanzil.net'),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copied tanzil.net')),
                );
              }
            },
            child: const Text(
              'tanzil.net',
              style: TextStyle(
                color: AppColors.emerald,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
