// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown instead of the surah index whenever the Quran feature is
// disabled — a missing asset or a failed verification, never a raw
// exception string.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../data/quran_import_status.dart';

class QuranImportNotice extends StatelessWidget {
  const QuranImportNotice({super.key, required this.status});

  final QuranImportStatus status;

  @override
  Widget build(BuildContext context) {
    final message = switch (status) {
      QuranAssetMissing() => 'Add a Quran source file to enable this feature.',
      QuranVerificationFailed() =>
        'Reinstall or update the app to restore the Quran text — the '
            'file on this device did not pass verification.',
      QuranImported() => '',
    };

    return Semantics(
      liveRegion: true,
      label: message,
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              color: AppColors.sage,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.sage),
            ),
          ],
        ),
      ),
    );
  }
}
