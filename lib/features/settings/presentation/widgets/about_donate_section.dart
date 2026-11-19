// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// About, Help, Feedback, Backup and Check for update. The Donate row
// was removed on 2026-11-19 (Play payments policy; Noor asks for
// nothing).

import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/app_card.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../about_screen.dart';
import '../help_screen.dart';
import '../backup_restore_screen.dart';
import '../send_feedback_screen.dart';
import 'check_update_row.dart';
import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';

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
            label: AppLocalizations.of(context)!.helpFaqLabel,
            hint: AppLocalizations.of(context)!.helpFaqHint,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const HelpScreen()),
            ),
            child: _Row(
              icon: Icons.help_outline,
              label: AppLocalizations.of(context)!.helpFaqLabel,
            ),
          ),
          const SizedBox(height: 4),
          SemanticButton(
            label: 'Send Feedback',
            hint: 'Double tap to report a bug or suggest an idea',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SendFeedbackScreen()),
            ),
            child: const _Row(icon: Icons.feedback_outlined, label: 'Send Feedback'),
          ),
          const SizedBox(height: 4),
          SemanticButton(
            label: 'Backup & Restore',
            hint: 'Double tap to export or restore an encrypted backup',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const BackupRestoreScreen()),
            ),
            child: const _Row(icon: Icons.security_outlined, label: 'Backup & Restore'),
          ),
          const SizedBox(height: 4),
          const CheckUpdateRow(),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.ink;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(label, style: AppTypography.body(color)),
        ],
      ),
    );
  }
}
