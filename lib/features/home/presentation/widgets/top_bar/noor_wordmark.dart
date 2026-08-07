// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// The brand mark shown in the persistent top bar: the existing Allah
// calligraphy plus a letterspaced "NOOR" wordmark underneath. Purely
// decorative/branding — not a navigation control, no Semantics tap
// target, matching AllahCalligraphy's own "purely decorative" contract.

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/presentation/widgets/allah_calligraphy.dart';

class NoorWordmark extends StatelessWidget {
  const NoorWordmark({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AllahCalligraphy(fontSize: 22),
        SizedBox(height: 2),
        Text(
          'NOOR',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 4,
            color: AppColors.gold,
          ),
        ),
      ],
    );
  }
}
