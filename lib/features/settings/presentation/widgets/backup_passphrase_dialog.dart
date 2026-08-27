// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Shared passphrase prompt for both export (asks twice, so a typo
// can't lock someone out of their own backup) and import (asks once).

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Returns the entered passphrase, or `null` if cancelled.
Future<String?> promptForPassphrase(
  BuildContext context, {
  required bool confirmationRequired,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _PassphraseDialog(confirmationRequired: confirmationRequired),
  );
}

class _PassphraseDialog extends StatefulWidget {
  const _PassphraseDialog({required this.confirmationRequired});
  final bool confirmationRequired;

  @override
  State<_PassphraseDialog> createState() => _PassphraseDialogState();
}

class _PassphraseDialogState extends State<_PassphraseDialog> {
  final _passphrase = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;

  void _submit() {
    if (_passphrase.text.length < 6) {
      setState(() => _error = 'Use at least 6 characters.');
      return;
    }
    if (widget.confirmationRequired && _passphrase.text != _confirm.text) {
      setState(() => _error = "Passphrases don't match.");
      return;
    }
    Navigator.of(context).pop(_passphrase.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.card,
      title: Text(
        widget.confirmationRequired ? 'Choose a backup passphrase' : 'Enter the backup passphrase',
        style: const TextStyle(color: AppColors.ink),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.confirmationRequired)
            const Text(
              "You'll need this to restore the backup later — noor doesn't "
              "store it anywhere, so if it's lost, the backup can't be "
              "recovered.",
              style: TextStyle(color: AppColors.sage, fontSize: 13),
            ),
          const SizedBox(height: 12),
          TextField(
            controller: _passphrase,
            obscureText: true,
            autofocus: true,
            style: const TextStyle(color: AppColors.ink),
            decoration: const InputDecoration(labelText: 'Passphrase'),
          ),
          if (widget.confirmationRequired) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _confirm,
              obscureText: true,
              style: const TextStyle(color: AppColors.ink),
              decoration: const InputDecoration(labelText: 'Confirm passphrase'),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: _submit, child: const Text('Continue')),
      ],
    );
  }
}
