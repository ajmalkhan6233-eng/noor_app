// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown whenever a category has no items yet — never a blank page.

import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/empty_state.dart';

class AzkarEmptyState extends StatelessWidget {
  const AzkarEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.menu_book_outlined,
      message:
          'Azkar text for this category has not been loaded yet. A '
          'properly sourced collection will be added in a future update.',
    );
  }
}
