// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Split out of HomeOverviewScreen to keep that file under the
// project's line-count convention.

import 'package:flutter/material.dart';

/// Shows a dialog to edit the free-text location label shown on the
/// dashboard header. Returns the trimmed text, or `null` if cancelled.
Future<String?> showEditLocationDialog(
  BuildContext context, {
  required String? current,
}) {
  final controller = TextEditingController(text: current);
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Location name'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'e.g. Amman, Jordan'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(controller.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
