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

import '../../../core/constants/app_typography.dart';
import '../../../core/constants/app_color_tokens.dart';
import 'support_button.dart';

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
      backgroundColor: context.colors.paper,
      appBar: AppBar(
        backgroundColor: context.colors.paper,
        title: Text('Support noor', style: TextStyle(color: context.colors.ink)),
        iconTheme: IconThemeData(color: context.colors.gold),
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
              style: AppTypography.caption(context.colors.sage).copyWith(color: context.colors.ink, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SupportButton(
              icon: Icons.chat_bubble_outline,
              label: 'Message on WhatsApp',
              filled: true,
              onTap: () => _requestViaWhatsApp(context),
            ),
            const SizedBox(height: 12),
            SupportButton(
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

