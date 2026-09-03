// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Page-by-page view of the entire Quran (2026-09-04, direct request:
// "convert [this] to page-turn too", extending the per-surah reader's
// page-turn treatment here — see widgets/paginated_full_quran_text.dart)
// covering all ~6,236 ayahs across all 114 surahs (see
// QuranCubit.loadFullQuran). A surah's name/audio header only ever
// appears on that surah's first page (full_quran_page_splitter.dart
// never splits a page across two surahs) — the same one-shot access
// pattern the previous continuous-scroll version already had.
//
// Tracks reading position the same way SurahReaderScreen does
// (ReadingPositionTracker + markLastRead), and jumps straight to the
// page containing it on reopen.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/reading_position_tracker.dart';
import '../data/surah_audio_player.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'widgets/paginated_full_quran_text.dart';
import '../../../core/constants/app_color_tokens.dart';

int _positionKey(int surahId, int ayahNumber) => surahId * 1000 + ayahNumber;

class FullQuranScreen extends StatefulWidget {
  const FullQuranScreen({super.key});

  @override
  State<FullQuranScreen> createState() => _FullQuranScreenState();
}

class _FullQuranScreenState extends State<FullQuranScreen> {
  final _itemKeys = <int, GlobalKey>{};
  final _audioPlayer = SurahAudioPlayer();
  int? _playingSurahId;

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().loadFullQuran();
    _audioPlayer.onComplete.listen((_) {
      if (mounted) setState(() => _playingSurahId = null);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio(int surahId) async {
    if (_playingSurahId == surahId) {
      await _audioPlayer.stop();
      setState(() => _playingSurahId = null);
    } else {
      await _audioPlayer.play(surahId);
      setState(() => _playingSurahId = surahId);
    }
  }

  GlobalKey _keyFor(int surahId, int ayahNumber) =>
      _itemKeys.putIfAbsent(_positionKey(surahId, ayahNumber), GlobalKey.new);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.paper,
      appBar: AppBar(
        backgroundColor: context.colors.paper,
        elevation: 0,
        title: const Text('The Full Quran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            final ayahs = state.fullQuranAyahs;
            if (ayahs == null) {
              return Center(child: CircularProgressIndicator(color: context.colors.gold));
            }
            final bookmarksBySurah = <int, Set<int>>{};
            for (final b in state.bookmarks) {
              bookmarksBySurah.putIfAbsent(b.surahId, () => {}).add(b.ayahNumber);
            }
            return ReadingPositionTracker(
              itemKeys: _itemKeys,
              onPositionChanged: (key) => context.read<QuranCubit>().markLastRead(key ~/ 1000, key % 1000),
              child: PaginatedFullQuranText(
                ayahs: ayahs,
                surahs: state.surahs,
                fontScale: state.arabicFontScale,
                bookmarkedAyahNumbers: (surahId) => bookmarksBySurah[surahId] ?? const {},
                onToggleBookmark: (surahId, ayahNumber) => context.read<QuranCubit>().toggleBookmark(surahId, ayahNumber),
                ayahKeyFor: _keyFor,
                playingSurahId: _playingSurahId,
                onToggleAudio: _toggleAudio,
                initialSurahId: state.lastRead?.surahId,
                initialAyahNumber: state.lastRead?.ayahNumber,
              ),
            );
          },
        ),
      ),
    );
  }
}
