// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// A surah's name/audio-button header row, shown only on that surah's
// first page inside paginated_full_quran_text.dart — split out to
// keep that file under the 150-line limit.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_typography.dart';
import 'full_quran_page_splitter.dart';
import 'surah_audio_button.dart';
import '../../../../core/constants/app_color_tokens.dart';

class FullQuranPageHeader extends StatelessWidget {
  const FullQuranPageHeader({
    super.key,
    required this.page,
    required this.isPlaying,
    required this.onToggleAudio,
  });

  final BookPage page;
  final bool isPlaying;
  final VoidCallback onToggleAudio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${page.surah.id}. ${page.surah.displayName}',
              style: AppTypography.sectionHeader(context.colors.sage).copyWith(color: context.colors.gold, fontSize: 20),
            ),
          ),
          SurahAudioButton(
            surahId: page.surah.id,
            isPlaying: isPlaying,
            onToggle: onToggleAudio,
          ),
        ],
      ),
    );
  }
}
