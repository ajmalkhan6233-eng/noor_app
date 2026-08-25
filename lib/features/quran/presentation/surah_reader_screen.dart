// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/presentation/widgets/reading_position_tracker.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/surah_audio_player.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'widgets/ayah_tile.dart';

/// Ayah-by-ayah view of one surah, with adjustable Arabic font size
/// (from Settings), bookmarking, and last-read tracking: scrolling
/// updates the saved position, and opening a surah with a saved
/// position scrolls straight to it.
class SurahReaderScreen extends StatefulWidget {
  const SurahReaderScreen({super.key, required this.surahId});

  final int surahId;

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  final _ayahKeys = <int, GlobalKey>{};
  var _scrolledToLastRead = false;
  final _audioPlayer = SurahAudioPlayer();
  var _playing = false;

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().openSurah(widget.surahId);
    _audioPlayer.onComplete.listen((_) {
      if (mounted) setState(() => _playing = false);
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_playing) {
      await _audioPlayer.stop();
      setState(() => _playing = false);
    } else {
      await _audioPlayer.play(widget.surahId);
      setState(() => _playing = true);
    }
  }

  GlobalKey _keyFor(int ayahNumber) =>
      _ayahKeys.putIfAbsent(ayahNumber, GlobalKey.new);

  void _maybeScrollToLastRead(QuranState state) {
    if (_scrolledToLastRead) return;
    final lastRead = state.lastRead;
    if (lastRead == null || lastRead.surahId != widget.surahId) return;
    _scrolledToLastRead = true;
    if (lastRead.ayahNumber <= 1) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _ayahKeys[lastRead.ayahNumber]?.currentContext;
      if (ctx != null) Scrollable.ensureVisible(ctx, alignment: 0.1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.surahReaderTitle(widget.surahId)),
        actions: [
          // Recitation audio is only bundled for Juz Amma (surahs
          // 78-114) — see surah_audio_player.dart's header for why
          // the rest isn't. No button at all for other surahs, rather
          // than one that always fails.
          if (hasSurahAudio(widget.surahId))
            IconButton(
              icon: Icon(_playing ? Icons.pause_circle_outline : Icons.play_circle_outline),
              color: AppColors.gold,
              tooltip: _playing ? 'Pause recitation' : 'Play recitation',
              onPressed: _toggleAudio,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state.currentSurahId != widget.surahId) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.gold),
              );
            }
            _maybeScrollToLastRead(state);
            return ReadingPositionTracker(
              itemKeys: _ayahKeys,
              onPositionChanged: (ayahNumber) => context
                  .read<QuranCubit>()
                  .markLastRead(widget.surahId, ayahNumber),
              child: ListView(
                children: [
                  for (final ayah in state.currentAyahs)
                    KeyedSubtree(
                      key: _keyFor(ayah.ayahNumber),
                      child: AyahTile(
                        ayah: ayah,
                        fontScale: state.arabicFontScale,
                        isBookmarked: state.bookmarks.any(
                          (b) =>
                              b.surahId == ayah.surahId &&
                              b.ayahNumber == ayah.ayahNumber,
                        ),
                        onToggleBookmark: () => context
                            .read<QuranCubit>()
                            .toggleBookmark(ayah.surahId, ayah.ayahNumber),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
