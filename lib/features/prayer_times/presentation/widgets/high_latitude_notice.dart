// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Shown instead of prayer times whenever the repository returns
/// `HighLatitudeUnresolved` — never a guessed clock time.
class HighLatitudeNotice extends StatelessWidget {
  const HighLatitudeNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final message = AppLocalizations.of(context)!.highLatitudeUnresolvedMessage;
    return Semantics(
      liveRegion: true,
      label: message,
      child: AppCard(
        child: Text(message, style: const TextStyle(color: AppColors.sage)),
      ),
    );
  }
}
