// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shows the dua/dhikr for a Tawaf or Sa'i step, loaded live from the
// SHA-256-verified asset via PilgrimageDuaRepository, or the app's
// standard "not loaded" message if verification fails. Never shows
// hard-coded Arabic text.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/presentation/widgets/section_header.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/pilgrimage_dua.dart';
import '../../data/pilgrimage_dua_repository.dart';

class PilgrimageDuaCard extends StatelessWidget {
  const PilgrimageDuaCard({
    super.key,
    required this.duaKey,
    required this.title,
    this.repository = const PilgrimageDuaRepository(),
  });

  final String duaKey;
  final String title;
  final PilgrimageDuaRepository repository;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<PilgrimageDua?>(
      future: repository.forKey(duaKey),
      builder: (context, snapshot) {
        final dua = snapshot.data;
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title),
              if (dua == null)
                Text(
                  l10n.guideTextNotLoadedMessage,
                  style: const TextStyle(color: AppColors.sage, fontStyle: FontStyle.italic),
                )
              else ...[
                Text(dua.arabicText, textAlign: TextAlign.right, style: AppTypography.arabic),
                const SizedBox(height: 8),
                Text(
                  l10n.reciteCountLabel(dua.repeatCount),
                  style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
