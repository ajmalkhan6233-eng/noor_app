// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A one-time, dismissible nudge toward the existing Support the
// Developer screen at a real milestone — shows once per milestoneKey,
// ever, then never again on that key. A function, not a widget:
// called from whichever screen hosts the milestone-triggering state
// (Cubits stay UI/navigation-free, per this app's architecture rule).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';
import '../../../../core/support/support_prompt_service.dart';
import '../../../settings/presentation/support_developer_screen.dart';

Future<void> maybeShowMilestoneNudge({
  required BuildContext context,
  required String milestoneKey,
  required String message,
}) async {
  final service = SupportPromptService();
  final shouldShow = await service.shouldShowMilestoneNudge(milestoneKey);
  if (!shouldShow || !context.mounted) return;

  await service.markMilestoneNudgeShown(milestoneKey);
  if (!context.mounted) return;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.colors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: sheetContext.colors.ink),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pop(sheetContext);
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SupportDeveloperScreen()),
              );
            },
            child: Text('Support noor', style: TextStyle(color: sheetContext.colors.gold)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(sheetContext),
            child: Text('Not now', style: TextStyle(color: sheetContext.colors.sage)),
          ),
        ],
      ),
    ),
  );
}
