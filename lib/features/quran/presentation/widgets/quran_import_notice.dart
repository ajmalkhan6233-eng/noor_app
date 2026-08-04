// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown instead of the surah index whenever the Quran feature is
// disabled — a missing asset or a failed verification, never a raw
// exception string.

import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/empty_state.dart';
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

    return EmptyState(icon: Icons.menu_book_outlined, message: message);
  }
}
