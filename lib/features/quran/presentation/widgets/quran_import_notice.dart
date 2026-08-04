// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown instead of the surah index whenever the Quran feature is
// disabled — a missing asset or a failed verification, never a raw
// exception string.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/empty_state.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/quran_import_status.dart';

class QuranImportNotice extends StatelessWidget {
  const QuranImportNotice({super.key, required this.status});

  final QuranImportStatus status;

  @override
  Widget build(BuildContext context) {
    final importing = status;
    if (importing is QuranImporting) {
      return _ImportingProgress(progress: importing.progress);
    }

    final l10n = AppLocalizations.of(context)!;
    final message = switch (status) {
      QuranAssetMissing() => l10n.quranAssetMissingMessage,
      QuranVerificationFailed() => l10n.quranVerificationFailedMessage,
      QuranImported() || QuranImporting() => '',
    };

    return EmptyState(icon: Icons.menu_book_outlined, message: message);
  }
}

class _ImportingProgress extends StatelessWidget {
  const _ImportingProgress({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final percent = (progress * 100).round();
    return Semantics(
      liveRegion: true,
      label: l10n.importingQuranProgressSemanticLabel(percent),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.importingQuranLabel,
                style: const TextStyle(color: AppColors.sage),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: AppColors.hairline,
                  color: AppColors.emerald,
                ),
              ),
              const SizedBox(height: 8),
              Text('$percent%', style: const TextStyle(color: AppColors.sage)),
            ],
          ),
        ),
      ),
    );
  }
}
