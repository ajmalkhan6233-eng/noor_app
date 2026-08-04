// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown whenever a category has no items yet — never a blank page.

import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/empty_state.dart';

class AzkarEmptyState extends StatelessWidget {
  const AzkarEmptyState({super.key, this.verificationFailed = false});

  /// True when a bundled dataset exists but failed SHA-256
  /// verification — a distinct message from "not sourced yet".
  final bool verificationFailed;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.menu_book_outlined,
      message: verificationFailed
          ? 'Reinstall or update the app to restore this category — '
                'the bundled data on this device did not pass verification.'
          : 'Azkar text for this category has not been loaded yet. A '
                'properly sourced collection will be added in a future update.',
    );
  }
}
