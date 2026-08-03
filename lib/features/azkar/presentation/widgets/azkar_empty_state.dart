// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shown whenever a category has no items yet — never a blank page.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AzkarEmptyState extends StatelessWidget {
  const AzkarEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    const message =
        'Azkar text for this category has not been loaded yet. A '
        'properly sourced collection will be added in a future update.';
    return Semantics(
      liveRegion: true,
      label: message,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, color: AppColors.textSecondary, size: 40),
            SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
