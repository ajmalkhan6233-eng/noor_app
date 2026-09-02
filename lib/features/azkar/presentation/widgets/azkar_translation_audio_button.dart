// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Play/pause control for one Azkar/Dua item's English translation,
// read aloud via on-device TTS (AzkarTranslationSpeechPlayer) — never
// the Arabic text or transliteration. Mirrors SurahAudioButton's
// available/unavailable shape: only the 34 adhkar-en.json entries have
// a populated `translation` field today (the other ~42 have no
// English text yet, a separate content task), so most items show this
// disabled with a clear reason rather than hiding it inconsistently.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_tokens.dart';

class AzkarTranslationAudioButton extends StatelessWidget {
  const AzkarTranslationAudioButton({
    super.key,
    required this.available,
    required this.isPlaying,
    required this.onToggle,
  });

  final bool available;
  final bool isPlaying;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: available
          ? (isPlaying ? 'Pause translation audio' : 'Play translation audio')
          : 'Translation audio unavailable for this dua',
      value: isPlaying ? 'Playing' : 'Stopped',
      hint: available
          ? 'Double tap to hear the English translation read aloud'
          : 'No English translation is available yet for this item',
      child: IconButton(
        icon: Icon(isPlaying ? Icons.pause_circle_outline : Icons.volume_up_outlined),
        iconSize: 20,
        color: available ? context.colors.gold : context.colors.sage,
        tooltip: available
            ? (isPlaying ? 'Pause translation audio' : 'Play translation audio')
            : 'Translation audio unavailable for this dua',
        onPressed: available ? onToggle : null,
      ),
    );
  }
}
