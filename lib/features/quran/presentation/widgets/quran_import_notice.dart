// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown instead of the surah index whenever the Quran feature is
// disabled — a missing asset or a failed verification, never a raw
// exception string.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/quran_import_status.dart';

class QuranImportNotice extends StatelessWidget {
  const QuranImportNotice({super.key, required this.status});

  final QuranImportStatus status;

  @override
  Widget build(BuildContext context) {
    final message = switch (status) {
      QuranAssetMissing() =>
        'The Quran feature is not yet set up on this device — no '
            'source text file has been added.',
      QuranVerificationFailed() =>
        'The Quran text file on this device failed verification, so '
            'it has not been loaded. Please reinstall or update the app.',
      QuranImported() => '',
    };

    return Semantics(
      liveRegion: true,
      label: message,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              color: AppColors.textSecondary,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
