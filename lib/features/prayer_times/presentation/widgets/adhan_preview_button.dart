// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Self-contained preview control — reads/drives AdhanPreviewCubit
// directly so PrayerTimesList doesn't need extra prop-drilling for
// something that isn't per-screen state (see prayer_notification_bell
// for the pattern this is styled after).

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/adhan_audio_player.dart';
import '../../logic/adhan_preview_cubit.dart';
import '../../logic/prayer_cubit/prayer_cubit.dart';
import '../../../../core/constants/app_color_tokens.dart';

class AdhanPreviewButton extends StatelessWidget {
  const AdhanPreviewButton({super.key, required this.prayerName});

  final String prayerName;

  @override
  Widget build(BuildContext context) {
    if (adhanAssetForPrayer(prayerName) == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AdhanPreviewCubit, String?>(
      builder: (context, previewing) {
        final isPlaying = previewing == prayerName;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: SemanticButton(
            label: l10n.previewAdhanSemanticLabel(prayerName),
            hint: isPlaying ? l10n.stopPreviewHint : l10n.playPreviewHint,
            onTap: () => context.read<AdhanPreviewCubit>().togglePreview(
              prayerName,
              reciter: context.read<PrayerCubit>().state.adhanReciter,
            ),
            child: Icon(
              isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline,
              size: 24,
              color: isPlaying ? context.colors.gold : context.colors.sage,
            ),
          ),
        );
      },
    );
  }
}
