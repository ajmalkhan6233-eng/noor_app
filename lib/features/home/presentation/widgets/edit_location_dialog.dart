// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of HomeOverviewScreen to keep that file under the
// project's line-count convention.

import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';

/// Shows a dialog to edit the free-text location label shown on the
/// dashboard header. Returns the trimmed text, or `null` if cancelled.
Future<String?> showEditLocationDialog(
  BuildContext context, {
  required String? current,
}) {
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController(text: current);
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.locationNameDialogTitle),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.locationNameHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(controller.text),
          child: Text(l10n.saveLabel),
        ),
      ],
    ),
  );
}
