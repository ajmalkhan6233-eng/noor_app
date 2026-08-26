// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Replaces the old inline "Donate" dialog: a full screen with a
// WhatsApp and an email path to personally request the developer's
// payment details, rather than any in-app payment flow (Play Billing
// would require the INTERNET permission and network calls — see
// noor-monetization-guardrails). Both buttons are an OS-level app
// handoff (url_launcher opening wa.me/mailto:), not a network call
// this app makes itself, so this adds no INTERNET permission.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/semantics_helpers.dart';

class SupportDeveloperScreen extends StatelessWidget {
  const SupportDeveloperScreen({super.key});

  static const String developerEmail = 'ajinfb@yahoo.com';
  static const String whatsappNumber = '94777999219'; // country code, no +, no leading 0s

  static const String _message =
      "Hi, I'd like to support noor's development. Could you share your payment details?";

  Future<void> _requestViaWhatsApp(BuildContext context) async {
    final uri = Uri.parse(
      'https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(_message)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      _showCantOpen(context, 'WhatsApp');
    }
  }

  Future<void> _requestViaEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: developerEmail,
      query:
          'subject=${Uri.encodeComponent("Support for noor")}&body=${Uri.encodeComponent(_message)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      _showCantOpen(context, 'an email app');
    }
  }

  // Without this, a tap on either button with no matching app installed
  // did nothing at all — no error, no indication anything was even
  // tapped (found while auditing "silently does nothing" bug patterns,
  // 2026-08-26).
  void _showCantOpen(BuildContext context, String appName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Couldn't open $appName — is it installed?")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        title: const Text('Support noor', style: TextStyle(color: AppColors.ink)),
        iconTheme: const IconThemeData(color: AppColors.gold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "noor is built and maintained by one developer, in personal "
              "time, with real costs behind it. If the app has been useful "
              "to you, a donation helps keep it going and improving.\n\n"
              "Send a message below and the developer will personally share "
              "payment details with you. This goes directly to the "
              "developer as an individual — it isn't a registered charity "
              "or organisation.",
              style: AppTypography.caption.copyWith(color: AppColors.ink, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _SupportButton(
              icon: Icons.chat_bubble_outline,
              label: 'Message on WhatsApp',
              filled: true,
              onTap: () => _requestViaWhatsApp(context),
            ),
            const SizedBox(height: 12),
            _SupportButton(
              icon: Icons.mail_outline,
              label: 'Send an Email',
              filled: false,
              onTap: () => _requestViaEmail(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SemanticButton(
        label: label,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: filled ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: filled ? null : Border.all(color: AppColors.goldBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: filled ? AppColors.paper : AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: filled ? AppColors.paper : AppColors.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
