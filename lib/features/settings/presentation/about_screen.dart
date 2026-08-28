// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/build_stamp_footer.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../core/utils/semantics_helpers.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'licences_screen.dart';
import 'privacy_policy_screen.dart';
import 'widgets/about_sources_card.dart';
import 'widgets/font_credit.dart';
import '../../../core/constants/app_color_tokens.dart';

/// About page: app identity, text-source attribution, bundled font
/// credits, and licences.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.colors.paper,
      appBar: AppBar(title: Text(l10n.aboutLabel)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          StaggeredFadeIn(
            children: [
              _identityCard(context),
              const SizedBox(height: 16),
              const AboutSourcesCard(),
              const SizedBox(height: 16),
              _religiousContentNoteCard(context, l10n),
              const SizedBox(height: 16),
              _fontCreditsCard(context),
              const SizedBox(height: 16),
              // Privacy Policy link intentionally hidden for now (not
              // deleted — _privacyPolicyLink() and PrivacyPolicyScreen
              // both still exist below) pending the developer's own
              // review of its content before showing it to users.
              _licencesLink(context),
              const SizedBox(height: 16),
              const BuildStampFooter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _identityCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.appName, style: AppTypography.heroDisplay(context.colors.ink)),
          const SizedBox(height: 8),
          Text(
            'This app is built to take Muslims from where they are to '
            'where they want to be. Every Muslim has a niyyah — a place '
            'he is in, and a place he wants to be, in his religion. This '
            'app was created to fill that gap, with a sincere and humble '
            'intention. Whoever can benefit from it, that is all we hope '
            'for.',
            style: TextStyle(color: context.colors.sage),
          ),
        ],
      ),
    );
  }

  Widget _religiousContentNoteCard(BuildContext context, AppLocalizations l10n) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(l10n.religiousContentNoteHeader),
          const SizedBox(height: 8),
          Text(l10n.religiousContentNoteBody, style: AppTypography.caption(context.colors.sage)),
        ],
      ),
    );
  }

  Widget _fontCreditsCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader('Typefaces'),
          const FontCredit(
            family: 'Cormorant Garamond',
            role: 'Display — prayer times, the Bismillah, headers',
          ),
          const SizedBox(height: 12),
          const FontCredit(family: 'Inter', role: 'Body — labels, settings, controls'),
          const SizedBox(height: 12),
          const FontCredit(
            family: 'Noto Sans Tamil',
            role: 'Tamil interface text',
          ),
          const SizedBox(height: 12),
          const FontCredit(
            family: 'Noto Sans Sinhala',
            role: 'Sinhala interface text',
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

  // Not called from build() right now — see the "hidden for now" note
  // above. Kept, not deleted: re-add its call site once the privacy
  // policy content has been reviewed.
  // ignore: unused_element
  Widget _privacyPolicyLink(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: SemanticButton(
        label: 'Privacy Policy',
        hint: 'Double tap to view the privacy policy',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const PrivacyPolicyScreen()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: context.colors.gold),
              const SizedBox(width: 12),
              Text(
                'Privacy Policy',
                style: TextStyle(color: context.colors.ink),
              ),
            ],
          ),
        ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.description_outlined, color: context.colors.gold),
              const SizedBox(width: 12),
              Text(
                'Open source licences',
                style: TextStyle(color: context.colors.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
