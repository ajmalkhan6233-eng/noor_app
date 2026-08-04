// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shows the Talbiyah loaded live from the SHA-256-verified asset via
// TalbiyahRepository, or the app's standard "not loaded" message if
// verification fails or the asset is missing. Never shows hard-coded
// Arabic text.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/talbiyah_entry.dart';
import '../../data/talbiyah_repository.dart';

class TalbiyahCard extends StatelessWidget {
  const TalbiyahCard({super.key, this.repository = const TalbiyahRepository()});

  final TalbiyahRepository repository;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<TalbiyahEntry?>(
      future: repository.load(),
      builder: (context, snapshot) {
        final entry = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(l10n.talbiyahSectionTitle),
            if (entry == null)
              Text(
                l10n.guideTextNotLoadedMessage,
                style: const TextStyle(color: AppColors.sage, fontStyle: FontStyle.italic),
              )
            else ...[
              Text(entry.arabicText, textAlign: TextAlign.right, style: AppTypography.arabic),
              if (entry.reference.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('${l10n.guideReferenceLabel}: ${entry.reference}', style: AppTypography.caption),
              ],
            ],
          ],
        );
      },
    );
  }
}
