// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Required even for a fully offline app (CLAUDE.md's Phase 3 release
// checklist) — a static page, no network call to fetch it. Every
// claim here is a direct statement of what this codebase actually
// does: no INTERNET permission in AndroidManifest.xml, no ad/
// analytics SDK in pubspec.yaml, location read via Geolocator and
// only ever written to the on-device encrypted database.

import 'package:flutter/material.dart';

import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/widgets/app_card.dart';
import '../../../core/presentation/widgets/section_header.dart';
import '../../../core/constants/app_color_tokens.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.paper,
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader('Summary'),
                SizedBox(height: 8),
                Text(
                  'noor does not collect, store, or transmit any personal '
                  'data to us or to any third party. There are no ads, no '
                  'analytics, and no account to create.',
                  style: TextStyle(color: context.colors.ink, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader('Location'),
                SizedBox(height: 8),
                Text(
                  'If you enable location, it is used only to calculate '
                  'prayer times and the Qibla direction for where you are. '
                  'It is read from the device, used on the device, and '
                  'never leaves the device — noor has no network '
                  'permission to send it anywhere even if it wanted to. '
                  'You can clear or change it at any time in Settings, or '
                  'pick a district manually instead.',
                  style: TextStyle(color: context.colors.ink, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader('What stays on your device'),
                SizedBox(height: 8),
                Text(
                  'Your prayer-tracker history, bookmarks, dhikr counts, '
                  'Zakat entries, and settings are stored in a locally '
                  'encrypted database and never sync anywhere. Uninstalling '
                  'the app deletes this data permanently.',
                  style: TextStyle(color: context.colors.ink, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader('Permissions'),
                SizedBox(height: 8),
                Text(
                  '• Location — prayer times and Qibla direction.\n'
                  '• Notifications and exact alarms — adhan and iqamah reminders.\n'
                  '• Do Not Disturb access — only if you turn on Silent Mode.\n\n'
                  'noor requests no internet access permission at all.',
                  style: TextStyle(color: context.colors.ink, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader('Contact'),
                SizedBox(height: 8),
                Text(
                  'Questions about this policy can be sent through the '
                  'Support noor screen.',
                  style: AppTypography.caption(context.colors.sage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
