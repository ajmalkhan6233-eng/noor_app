// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../core/utils/semantics_helpers.dart';
import 'licences_screen.dart';
import 'widgets/about_sources_card.dart';
import 'widgets/font_credit.dart';

/// About page: app identity, text-source attribution, bundled font
/// credits, and licences.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          StaggeredFadeIn(
            children: [
              _identityCard(),
              const SizedBox(height: 16),
              const AboutSourcesCard(),
              const SizedBox(height: 16),
              _fontCreditsCard(),
              const SizedBox(height: 16),
              _licencesLink(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _identityCard() {
    return AppCard(
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
    );
  }

  Widget _fontCreditsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionHeader('Typefaces'),
          FontCredit(
            family: 'Cormorant Garamond',
            role: 'Display — prayer times, the Bismillah, headers',
          ),
          SizedBox(height: 12),
          FontCredit(family: 'Inter', role: 'Body — labels, settings, controls'),
          SizedBox(height: 12),
          FontCredit(family: 'Amiri', role: 'Arabic text'),
          SizedBox(height: 12),
          FontCredit(
            family: 'Noto Sans Tamil',
            role: 'Tamil interface text',
          ),
          SizedBox(height: 12),
          FontCredit(
            family: 'Noto Sans Sinhala',
            role: 'Sinhala interface text',
          ),
          SizedBox(height: 8),
          Text(
            'Each is licensed under the SIL Open Font Licence 1.1 and '
            'bundled with the app for fully offline use.',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }

  Widget _licencesLink(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: SemanticButton(
        label: 'Open source licences',
        hint: 'Double tap to view third-party licences',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const LicencesScreen()),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.description_outlined, color: AppColors.emerald),
              SizedBox(width: 12),
              Text(
                'Open source licences',
                style: TextStyle(color: AppColors.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
