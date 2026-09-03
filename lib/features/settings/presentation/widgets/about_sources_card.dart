// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Tanzil's terms of use require the source to be clearly indicated
// and a link made to tanzil.net — this card is that attribution.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_color_tokens.dart';

class AboutSourcesCard extends StatelessWidget {
  const AboutSourcesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(l10n.textSourcesHeader),
          Text(l10n.quranSourceAttribution, style: AppTypography.caption(context.colors.sage)),
          const SizedBox(height: 8),
          SemanticButton(
            label: l10n.copyTanzilLinkSemanticLabel,
            hint: l10n.copyTanzilLinkHint,
            onTap: () async {
              await Clipboard.setData(
                const ClipboardData(text: 'https://tanzil.net'),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.copiedTanzilMessage)),
                );
              }
            },
            child: Text(
              'tanzil.net',
              style: TextStyle(
                color: context.colors.gold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(l10n.englishTranslationAttribution, style: AppTypography.caption(context.colors.sage)),
          const SizedBox(height: 12),
          // Recitation audio (Juz Amma plus a few individually curated
          // surahs — see assets/quran/audio/juz_amma/README.md and
          // assets/quran/audio/popular/README.md) is CC BY 4.0, which
          // requires attribution as a licence condition, not just a
          // courtesy. Both sets are the same reciter/source item, so
          // one attribution line covers both.
          Text(
            'Recitation audio (Juz Amma and curated surahs): Moeed '
            'Alharthi, Hafs narration — Dhikr Al-Huda collection, CC BY 4.0.',
            style: AppTypography.caption(context.colors.sage),
          ),
          const SizedBox(height: 12),
          // MIT requires the permission notice to travel with copies of
          // the work — this is that notice for the two Azkar datasets
          // (see assets/azkar/README.md), which had no attribution
          // anywhere in the UI until now (2026-08-25 audit).
          Text(
            'Azkar text: Morning-And-Evening-Adhkar-DB (Seen-Arabic) and '
            'HisnElMuslim (asellam), MIT licence.',
            style: AppTypography.caption(context.colors.sage),
          ),
          // No Talbiyah/pilgrimage attribution here: the Hajj/Umrah
          // guide and pilgrimage tracker were cut from v1 and their
          // source and assets were removed entirely (2026-08-26) —
          // nothing from either ships anymore, so nothing needs
          // crediting.
        ],
      ),
    );
  }
}
