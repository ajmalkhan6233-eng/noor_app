// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';

class FontCredit extends StatelessWidget {
  const FontCredit({super.key, required this.family, required this.role});

  final String family;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(family, style: const TextStyle(color: AppColors.parchment)),
        Text(role, style: AppTypography.caption),
      ],
    );
  }
}
