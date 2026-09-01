// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/reading_position_tracker.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/surah_audio_player.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'widgets/paginated_surah_text.dart';
import 'widgets/surah_audio_button.dart';
import '../../../core/constants/app_color_tokens.dart';

/// Page-by-page view of one surah (2026-09-01: swipeable pages with a
/// turning transition, replacing a single continuous scroll — see
/// paginated_surah_text.dart), with adjustable Arabic font size (from
/// Settings), bookmarking, and last-read tracking: opening a surah
/// with a saved position jumps straight to the page containing it.
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

  /// Resolved once per screen open, then handed to PaginatedSurahText
  /// as its initial page target — jumping to a page (unlike scrolling)
  /// only makes sense once, before the reader has settled anywhere.
  int? _initialAyahNumber(QuranState state) {
    if (_scrolledToLastRead) return null;
    _scrolledToLastRead = true;
    final lastRead = state.lastRead;
    if (lastRead == null || lastRead.surahId != widget.surahId) return null;
    return lastRead.ayahNumber;
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
            final bookmarked = {
              for (final b in state.bookmarks)
                if (b.surahId == widget.surahId) b.ayahNumber,
            };
            return ReadingPositionTracker(
              itemKeys: _ayahKeys,
              onPositionChanged: (ayahNumber) => context
                  .read<QuranCubit>()
                  .markLastRead(widget.surahId, ayahNumber),
              child: PaginatedSurahText(
                ayahs: state.currentAyahs,
                fontScale: state.arabicFontScale,
                bookmarkedAyahNumbers: bookmarked,
                onToggleBookmark: (ayahNumber) => context
                    .read<QuranCubit>()
                    .toggleBookmark(widget.surahId, ayahNumber),
                ayahKeyFor: _keyFor,
                initialAyahNumber: _initialAyahNumber(state),
              ),
            );
          },
        ),
      ),
    );
  }
}
