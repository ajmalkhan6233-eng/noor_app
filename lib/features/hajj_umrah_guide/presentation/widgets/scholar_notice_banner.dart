// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The persistent, always-visible reminder every guide screen carries:
// this app's instructions are not a substitute for a scholar or Hajj
// group. Not a dismissible dialog — always on screen.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ScholarNoticeBanner extends StatelessWidget {
  const ScholarNoticeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      liveRegion: true,
      label: l10n.scholarConfirmationNotice,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: AppColors.emeraldSoft.withValues(alpha: 0.35),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.emerald, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.scholarConfirmationNotice,
                style: const TextStyle(color: AppColors.ink, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
