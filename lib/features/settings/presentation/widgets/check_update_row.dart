// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// "Check for update" opens noor's Play Store page; the Store itself shows
// an Update button when a newer version exists. No network call in the app.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/haptics/haptic_service.dart';
import '../../../../core/utils/semantics_helpers.dart';

const _packageId = 'com.noorapp.noorprayer';

class CheckUpdateRow extends StatelessWidget {
  const CheckUpdateRow({super.key});

  Future<void> _open(BuildContext context) async {
    const HapticService().tap();
    final messenger = ScaffoldMessenger.of(context);
    final uris = [
      Uri.parse('market://details?id=$_packageId'),
      Uri.parse('https://play.google.com/store/apps/details?id=$_packageId'),
    ];
    for (final uri in uris) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
      } catch (_) {}
    }
    messenger.showSnackBar(
      const SnackBar(content: Text('Could not open the Play Store.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SemanticButton(
      label: 'Check for update',
      hint: 'Double tap to open noor on the Play Store',
      onTap: () => _open(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(Icons.system_update_outlined, color: context.colors.ink),
            const SizedBox(width: 12),
            Text('Check for update', style: AppTypography.body(context.colors.ink)),
          ],
        ),
      ),
    );
  }
}
