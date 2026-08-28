// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Same WhatsApp/email handoff pattern as support_developer_screen.dart
// — an OS-level app handoff (url_launcher opening wa.me/mailto:), not
// a network call this app makes itself, so this adds no INTERNET
// permission. Kept as its own screen rather than folded into Support
// the Developer since the two have different intents (a bug report or
// suggestion vs. a donation) and different message bodies.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_typography.dart';
import '../../../core/utils/semantics_helpers.dart';
import 'support_developer_screen.dart';
import '../../../core/constants/app_color_tokens.dart';

class SendFeedbackScreen extends StatelessWidget {
  const SendFeedbackScreen({super.key});

  static const String _message =
      "Hi, I'd like to share some feedback about noor: ";

  Future<void> _sendViaWhatsApp(BuildContext context) async {
    final uri = Uri.parse(
      'https://wa.me/${SupportDeveloperScreen.whatsappNumber}'
      '?text=${Uri.encodeComponent(_message)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      _showCantOpen(context, 'WhatsApp');
    }
  }

  Future<void> _sendViaEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: SupportDeveloperScreen.developerEmail,
      query:
          'subject=${Uri.encodeComponent("Feedback for noor")}&body=${Uri.encodeComponent(_message)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      _showCantOpen(context, 'an email app');
    }
  }

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
        title: Text('Send Feedback', style: TextStyle(color: context.colors.ink)),
        iconTheme: IconThemeData(color: context.colors.gold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Found a bug, or have an idea for noor? Send a message below "
              "and it goes straight to the developer — no ticket system, "
              "no account needed.",
              style: AppTypography.caption(context.colors.sage).copyWith(color: context.colors.ink, fontSize: 14),
            ),
            const SizedBox(height: 24),
            _FeedbackButton(
              icon: Icons.chat_bubble_outline,
              label: 'Message on WhatsApp',
              filled: true,
              onTap: () => _sendViaWhatsApp(context),
            ),
            const SizedBox(height: 12),
            _FeedbackButton(
              icon: Icons.mail_outline,
              label: 'Send an Email',
              filled: false,
              onTap: () => _sendViaEmail(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({
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
            color: filled ? context.colors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: filled ? null : Border.all(color: context.colors.goldBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: filled ? context.colors.paper : context.colors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: filled ? context.colors.paper : context.colors.gold,
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
