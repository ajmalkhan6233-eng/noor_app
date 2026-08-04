// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../core/utils/semantics_helpers.dart';
import 'licences_screen.dart';

/// About page: app identity, bundled font credits, and licences.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(AppStrings.appName, style: AppTypography.heroDisplay),
                const SizedBox(height: 8),
                const Text(
                  'A clean, privacy-first, ad-free Islamic utility app. '
                  'Fully offline: no ads, no analytics, no remote telemetry.',
                  style: TextStyle(color: AppColors.sage),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SectionHeader('Typefaces'),
                _FontCredit(
                  family: 'Cormorant Garamond',
                  role: 'Display — prayer times, the Bismillah, headers',
                ),
                SizedBox(height: 12),
                _FontCredit(
                  family: 'Inter',
                  role: 'Body — labels, settings, controls',
                ),
                SizedBox(height: 12),
                _FontCredit(
                  family: 'Amiri',
                  role: 'Arabic text',
                ),
                SizedBox(height: 8),
                Text(
                  'Each is licensed under the SIL Open Font Licence 1.1 and '
                  'bundled with the app for fully offline use.',
                  style: TextStyle(color: AppColors.sage, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: EdgeInsets.zero,
            child: SemanticButton(
              label: 'Open source licences',
              hint: 'Double tap to view third-party licences',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const LicencesScreen(),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, color: AppColors.gold),
                    SizedBox(width: 12),
                    Text(
                      'Open source licences',
                      style: TextStyle(color: AppColors.parchment),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FontCredit extends StatelessWidget {
  const _FontCredit({required this.family, required this.role});

  final String family;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(family, style: const TextStyle(color: AppColors.parchment)),
        Text(role, style: const TextStyle(color: AppColors.sage, fontSize: 12)),
      ],
    );
  }
}
