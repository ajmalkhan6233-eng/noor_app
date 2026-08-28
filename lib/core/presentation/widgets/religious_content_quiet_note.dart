// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The small, quiet "under continuing scholarly review" note shown on
// the Quran and Azkar screens — deliberately not a banner or dialog,
// just a caption-sized line so it never competes with the actual
// content. See About's "A note on religious content" for the fuller
// version. Exact wording is fixed — do not paraphrase.

import 'package:flutter/material.dart';

import '../../constants/app_typography.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/constants/app_color_tokens.dart';

class ReligiousContentQuietNote extends StatelessWidget {
  const ReligiousContentQuietNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        l10n.religiousContentQuietNote,
        style: AppTypography.caption(context.colors.sage).copyWith(color: context.colors.sage),
      ),
    );
  }
}
