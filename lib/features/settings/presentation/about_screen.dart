// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/motion/staggered_fade_in.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/build_stamp_footer.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'help_screen.dart';
import 'licences_screen.dart';
import 'privacy_policy_screen.dart';
import 'widgets/about_sources_card.dart';
import 'widgets/about_font_credits_card.dart';
import 'widgets/about_link_card.dart';
import 'widgets/about_privacy_card.dart';
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
              const AboutFontCreditsCard(),
              const SizedBox(height: 16),
              const AboutPrivacyCard(),
              const SizedBox(height: 16),
              AboutLinkCard(
                icon: Icons.privacy_tip_outlined,
                label: l10n.privacyPolicyLabel,
                hint: l10n.privacyPolicyHint,
                builder: (_) => const PrivacyPolicyScreen(),
              ),
              const SizedBox(height: 12),
              AboutLinkCard(
                icon: Icons.help_outline,
                label: l10n.helpFaqLabel,
                hint: l10n.helpFaqHint,
                builder: (_) => const HelpScreen(),
              ),
              const SizedBox(height: 12),
              AboutLinkCard(
                icon: Icons.description_outlined,
                label: l10n.licencesLabel,
                hint: l10n.licencesHint,
                builder: (_) => const LicencesScreen(),
              ),
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
            style: AppTypography.body(context.colors.sage),
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
}
