// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A one-time, plain-language explanation shown the first time someone
// taps a download icon — not buried in Settings, said at the point it
// actually matters, per this feature's own scoping requirement.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_color_tokens.dart';

const _prefsKey = 'has_seen_audio_download_disclosure';

/// Shows the disclosure dialog once, ever, per device — returns
/// immediately (no dialog) on every call after the first. Always
/// `await` this before starting a download.
Future<void> maybeShowAudioDownloadDisclosure(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_prefsKey) == true) return;
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: context.colors.card,
      title: Text('Downloading requires internet', style: TextStyle(color: context.colors.ink)),
      content: Text(
        'Downloading audio requires an internet connection for this '
        'feature only. Nothing else in noor ever connects online.',
        style: TextStyle(color: context.colors.sage),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Got it', style: TextStyle(color: context.colors.gold)),
        ),
      ],
    ),
  );
  await prefs.setBool(_prefsKey, true);
}
