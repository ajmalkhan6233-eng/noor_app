// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// About sits with the rest of Settings navigation. Donate is a single
// quiet entry at the very bottom — no badge, no popup, no prompt
// anywhere else in the app.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../about_screen.dart';
import '../support_developer_screen.dart';

class AboutDonateSection extends StatelessWidget {
  const AboutDonateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SemanticButton(
            label: 'About noor',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
            ),
            child: const _Row(icon: Icons.info_outline, label: 'About'),
          ),
          const SizedBox(height: 4),
          SemanticButton(
            label: 'Donate',
            hint: 'Double tap for ways to support this project',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SupportDeveloperScreen()),
            ),
            child: const _Row(
              icon: Icons.favorite_border,
              label: 'Donate',
              muted: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label, this.muted = false});

  final IconData icon;
  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final color = muted ? AppColors.sage : AppColors.ink;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
