// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/reading_position_tracker.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/surah_audio_player.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'widgets/continuous_surah_text.dart';
import 'widgets/surah_audio_button.dart';
import '../../../core/constants/app_color_tokens.dart';

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
      backgroundColor: context.colors.paper,
      appBar: AppBar(
        backgroundColor: context.colors.paper,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.surahReaderTitle(widget.surahId)),
        actions: [
          SurahAudioButton(surahId: widget.surahId, isPlaying: _playing, onToggle: _toggleAudio),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state.currentSurahId != widget.surahId) {
              return Center(
                child: CircularProgressIndicator(color: context.colors.gold),
              );
            }
            _maybeScrollToLastRead(state);
            final bookmarked = {
              for (final b in state.bookmarks)
                if (b.surahId == widget.surahId) b.ayahNumber,
            };
            return ReadingPositionTracker(
              itemKeys: _ayahKeys,
              onPositionChanged: (ayahNumber) => context
                  .read<QuranCubit>()
                  .markLastRead(widget.surahId, ayahNumber),
              child: SingleChildScrollView(
                child: ContinuousSurahText(
                  ayahs: state.currentAyahs,
                  fontScale: state.arabicFontScale,
                  bookmarkedAyahNumbers: bookmarked,
                  onToggleBookmark: (ayahNumber) => context
                      .read<QuranCubit>()
                      .toggleBookmark(widget.surahId, ayahNumber),
                  ayahKeyFor: _keyFor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
