// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// AyahOfDayCard's "read full Quran" CTA — split out to keep that file
// under the project's line-count convention.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../quran/presentation/quran_screen.dart';

class AyahOfDayCta extends StatelessWidget {
  const AyahOfDayCta({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: l10n.fullQuranCtaLabel,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const QuranScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.gold, AppColors.accentSecondary],
          ),
        ),
        child: Text(
          l10n.fullQuranCtaLabel,
          style: const TextStyle(color: AppColors.paper, fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
    );
  }
}
