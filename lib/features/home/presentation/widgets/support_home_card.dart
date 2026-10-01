// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Quiet, dismissible mention of the existing Support the Developer
// screen. Dismiss once and it's gone for good from Home — the full
// screen stays reachable from More > About at any time. Never inside
// Quran or Prayer Times, per the locked decision this implements.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/support/support_prompt_service.dart';
import '../../../../core/utils/semantics_helpers.dart';
import '../../../settings/presentation/support_developer_screen.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/corner_radius.dart';
import '../../../../core/constants/app_typography.dart';

class SupportHomeCard extends StatefulWidget {
  const SupportHomeCard({super.key});

  @override
  State<SupportHomeCard> createState() => _SupportHomeCardState();
}

class _SupportHomeCardState extends State<SupportHomeCard> {
  final _service = SupportPromptService();
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _checkDismissed();
  }

  Future<void> _checkDismissed() async {
    final dismissed = await _service.isHomeCardDismissed();
    if (mounted) setState(() => _visible = !dismissed);
  }

  Future<void> _dismiss() async {
    await _service.dismissHomeCard();
    if (mounted) setState(() => _visible = false);
  }

  void _openSupportScreen() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SupportDeveloperScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(context.radiusFor(14)),
        border: Border.all(color: context.colors.accentSecondary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SemanticButton(
              label: AppLocalizations.of(context)!.supportHomeSemantics,
              onTap: _openSupportScreen,
              child: Text(
                AppLocalizations.of(context)!.supportHomeMessage,
                style: TextStyle(color: context.colors.sage, fontSize: AppTypography.captionSize),
              ),
            ),
          ),
          SemanticButton(
            label: AppLocalizations.of(context)!.supportHomeDismiss,
            onTap: _dismiss,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(Icons.close, size: 18, color: context.colors.hairline),
            ),
          ),
        ],
      ),
    );
  }
}
