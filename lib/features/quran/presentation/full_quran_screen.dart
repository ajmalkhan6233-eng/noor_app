// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One continuous, scrollable column covering the entire Quran —
// requested alongside the existing per-surah breakdown (2026-08-24
// live-device review: "I need one column with the entire Quran").
// All ~6,236 ayahs load once (see QuranCubit.loadFullQuran); grouped
// into 114 surah sections (FullQuranSurahSection) rather than one
// list item per ayah — cheaper to build AND fixes a real gap found
// 2026-08-31 (checking a report that "the play button is missing"):
// this screen had no audio control anywhere before, unlike the
// per-surah reader. Each section also renders its ayahs as one
// continuous flowing block instead of a card per ayah, matching the
// same redesign as the per-surah reader.
//
// Tracks reading position the same way SurahReaderScreen does
// (ReadingPositionTracker + markLastRead), and jumps straight back to
// it on reopen — previously this view had no memory of where someone
// stopped, unlike the per-surah reader (2026-08-25 live-device
// review: "when I'm halfway... I should be able to mark it"). The
// existing per-ayah bookmark mark already covers "mark a specific
// spot to find again later"; this covers "resume where I left off"
// without needing to bookmark every stopping point.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/widgets/reading_position_tracker.dart';
import '../data/quran_ayah.dart';
import '../data/quran_surah.dart';
import '../data/surah_audio_player.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'widgets/full_quran_surah_section.dart';
import '../../../core/constants/app_color_tokens.dart';

int _positionKey(int surahId, int ayahNumber) => surahId * 1000 + ayahNumber;

class FullQuranScreen extends StatefulWidget {
  const FullQuranScreen({super.key});

  @override
  State<FullQuranScreen> createState() => _FullQuranScreenState();
}

class _FullQuranScreenState extends State<FullQuranScreen> {
  final _itemKeys = <int, GlobalKey>{};
  var _scrolledToLastRead = false;
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

  void _maybeScrollToLastRead(QuranState state) {
    if (_scrolledToLastRead) return;
    final lastRead = state.lastRead;
    if (lastRead == null) return;
    _scrolledToLastRead = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _itemKeys[_positionKey(lastRead.surahId, lastRead.ayahNumber)];
      final ctx = key?.currentContext;
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
        title: const Text('The Full Quran'),
      ),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          final ayahs = state.fullQuranAyahs;
          if (ayahs == null) {
            return Center(child: CircularProgressIndicator(color: context.colors.gold));
          }
          _maybeScrollToLastRead(state);
          final sections = _groupBySurah(ayahs, state.surahs);
          final bookmarksBySurah = <int, Set<int>>{};
          for (final b in state.bookmarks) {
            bookmarksBySurah.putIfAbsent(b.surahId, () => {}).add(b.ayahNumber);
          }
          return ReadingPositionTracker(
            itemKeys: _itemKeys,
            onPositionChanged: (key) => context.read<QuranCubit>().markLastRead(key ~/ 1000, key % 1000),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return FullQuranSurahSection(
                  surah: section.surah,
                  ayahs: section.ayahs,
                  fontScale: state.arabicFontScale,
                  bookmarkedAyahNumbers: bookmarksBySurah[section.surah.id] ?? const {},
                  isPlaying: _playingSurahId == section.surah.id,
                  onToggleAudio: () => _toggleAudio(section.surah.id),
                  onToggleBookmark: (ayahNumber) => context.read<QuranCubit>().toggleBookmark(section.surah.id, ayahNumber),
                  ayahKeyFor: (ayahNumber) => _keyFor(section.surah.id, ayahNumber),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<_SurahSection> _groupBySurah(List<QuranAyah> ayahs, List<QuranSurah> surahs) {
    final surahsById = {for (final s in surahs) s.id: s};
    final sections = <_SurahSection>[];
    for (final ayah in ayahs) {
      if (sections.isEmpty || sections.last.surah.id != ayah.surahId) {
        final surah = surahsById[ayah.surahId] ?? QuranSurah(id: ayah.surahId, ayahCount: 0);
        sections.add(_SurahSection(surah, []));
      }
      sections.last.ayahs.add(ayah);
    }
    return sections;
  }
}

class _SurahSection {
  _SurahSection(this.surah, this.ayahs);
  final QuranSurah surah;
  final List<QuranAyah> ayahs;
}
