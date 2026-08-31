// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Reusable play/pause control for one surah's bundled recitation —
// shared by SurahReaderScreen (in its AppBar) and, as of 2026-08-31,
// FullQuranScreen (per surah section) — the latter had no audio
// control at all before, a real gap found while checking the report
// that "the play button is missing," not a rendering bug in an
// existing control.

import 'package:flutter/material.dart';

import '../../data/surah_audio_player.dart';
import '../../../../core/constants/app_color_tokens.dart';

class SurahAudioButton extends StatelessWidget {
  const SurahAudioButton({
    super.key,
    required this.surahId,
    required this.isPlaying,
    required this.onToggle,
  });

  final int surahId;
  final bool isPlaying;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final available = hasSurahAudio(surahId);
    return Semantics(
      button: true,
      label: available
          ? (isPlaying ? 'Pause recitation' : 'Play recitation')
          : 'Recitation unavailable for this Surah',
      value: isPlaying ? 'Playing' : 'Stopped',
      hint: available
          ? 'Double tap to control recitation'
          : 'Only Juz Amma recitations are bundled offline',
      child: IconButton(
        icon: Icon(isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline),
        color: available ? context.colors.gold : context.colors.sage,
        tooltip: available
            ? (isPlaying ? 'Pause recitation' : 'Play recitation')
            : 'Recitation unavailable for this Surah',
        onPressed: available ? onToggle : null,
      ),
    );
  }
}
