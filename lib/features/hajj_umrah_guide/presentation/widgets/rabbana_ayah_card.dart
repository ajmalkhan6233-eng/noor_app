// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The Rabbana ayah (Qur'an 2:201), read live from QuranRepository —
// which only ever returns text that came from the user's own
// SHA-256-verified Tanzil import. Shows the app's standard "not
// loaded" message if the Quran hasn't been imported yet. No Arabic
// text is hard-coded here.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../quran/data/quran_ayah.dart';
import '../../../quran/data/quran_repository.dart';

class RabbanaAyahCard extends StatelessWidget {
  RabbanaAyahCard({super.key, QuranRepository? repository})
    : _repository = repository ?? QuranRepository();

  final QuranRepository _repository;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<QuranAyah?>(
      future: _repository.singleAyah(2, 201),
      builder: (context, snapshot) {
        final ayah = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(l10n.rabbanaSectionTitle),
            if (ayah == null)
              Text(
                l10n.guideTextNotLoadedMessage,
                style: const TextStyle(color: AppColors.sage, fontStyle: FontStyle.italic),
              )
            else ...[
              Text(ayah.arabicText, textAlign: TextAlign.right, style: AppTypography.arabic),
              if (ayah.translation != null && ayah.translation!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(ayah.translation!, style: AppTypography.caption),
              ],
            ],
          ],
        );
      },
    );
  }
}
