// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_typography.dart';

/// Plain-language explanation of how the percentage is worked out.
Future<void> showProgressHelpSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.colors.card,
    isScrollControlled: true,
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext)!;
      final colors = sheetContext.colors;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.progressHelpTitle,
                  style: TextStyle(color: colors.ink, fontSize: AppTypography.timeLargeSize, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              Text(l10n.progressHelpBody, style: TextStyle(color: colors.ink, height: 1.5)),
              const SizedBox(height: 12),
              Text(l10n.progressHelpStreak, style: TextStyle(color: colors.sage, height: 1.5)),
              const SizedBox(height: 12),
              Text(l10n.progressHelpPrivacy, style: TextStyle(color: colors.sage, height: 1.5)),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(l10n.progressHelpClose, style: AppTypography.body(colors.gold)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
