// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One surah's worth of content inside FullQuranScreen's list: header
// (name + play button, 2026-08-31 — FullQuranScreen had no audio
// control anywhere before this, a real gap, not a rendering bug) plus
// its ayahs as one continuous flowing block (ContinuousSurahText),
// replacing the previous one-AyahTile-per-list-item structure.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import '../../data/quran_ayah.dart';
import '../../data/quran_surah.dart';
import 'continuous_surah_text.dart';
import 'surah_audio_button.dart';
import '../../../../core/constants/app_color_tokens.dart';

class FullQuranSurahSection extends StatelessWidget {
  const FullQuranSurahSection({
    super.key,
    required this.surah,
    required this.ayahs,
    required this.fontScale,
    required this.bookmarkedAyahNumbers,
    required this.isPlaying,
    required this.onToggleAudio,
    required this.onToggleBookmark,
    required this.ayahKeyFor,
  });

  final QuranSurah surah;
  final List<QuranAyah> ayahs;
  final double fontScale;
  final Set<int> bookmarkedAyahNumbers;
  final bool isPlaying;
  final VoidCallback onToggleAudio;
  final ValueChanged<int> onToggleBookmark;
  final GlobalKey Function(int ayahNumber) ayahKeyFor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${surah.id}. ${surah.displayName}',
                  style: AppTypography.sectionHeader(context.colors.sage).copyWith(color: context.colors.gold, fontSize: 20),
                ),
              ),
              SurahAudioButton(surahId: surah.id, isPlaying: isPlaying, onToggle: onToggleAudio),
            ],
          ),
          const SizedBox(height: 8),
          ContinuousSurahText(
            ayahs: ayahs,
            fontScale: fontScale,
            bookmarkedAyahNumbers: bookmarkedAyahNumbers,
            onToggleBookmark: onToggleBookmark,
            ayahKeyFor: ayahKeyFor,
          ),
        ],
      ),
    );
  }
}
