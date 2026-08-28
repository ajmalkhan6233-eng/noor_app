// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A quiet, letterspaced label above a section's content — never gold,
// never bold. Punctuation belongs to the content, not its caption.

import 'package:flutter/material.dart';

import '../../constants/app_typography.dart';
import '../../../core/constants/app_color_tokens.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title.toUpperCase(), style: AppTypography.sectionHeader(context.colors.sage)),
    );
  }
}
