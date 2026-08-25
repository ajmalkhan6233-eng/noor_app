// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One continuous, scrollable column covering the entire Quran —
// requested alongside the existing per-surah breakdown (2026-08-24
// live-device review: "I need one column with the entire Quran").
// All ~6,236 ayahs load once (see QuranCubit.loadFullQuran), but
// ListView.builder only ever builds the tiles actually on screen, so
// this stays cheap to render regardless of length.
//
// Tracks reading position the same way SurahReaderScreen does
// (ReadingPositionTracker + markLastRead), and jumps straight back to
// it on reopen — previously this view had no memory of where someone
// stopped, unlike the per-surah reader (2026-08-25 live-device
// review: "when I'm halfway... I should be able to mark it"). The
// existing per-ayah bookmark icon already covers "mark a specific
// spot to find again later"; this covers "resume where I left off"
// without needing to bookmark every stopping point.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/presentation/widgets/reading_position_tracker.dart';
import '../data/quran_ayah.dart';
import '../data/quran_surah.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'widgets/ayah_tile.dart';

// Ayah numbers never reach 1000, so surahId*1000+ayahNumber is a safe
// unique int key without needing a (surah, ayah) record as a Map key.
int _positionKey(int surahId, int ayahNumber) => surahId * 1000 + ayahNumber;

class FullQuranScreen extends StatefulWidget {
  const FullQuranScreen({super.key});

  @override
  State<FullQuranScreen> createState() => _FullQuranScreenState();
}

class _FullQuranScreenState extends State<FullQuranScreen> {
  final _itemKeys = <int, GlobalKey>{};
  var _scrolledToLastRead = false;

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().loadFullQuran();
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
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        elevation: 0,
        title: const Text('The Full Quran'),
      ),
      body: BlocBuilder<QuranCubit, QuranState>(
        builder: (context, state) {
          final ayahs = state.fullQuranAyahs;
          if (ayahs == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          _maybeScrollToLastRead(state);
          final items = _buildItems(ayahs, state.surahs);
          return ReadingPositionTracker(
            itemKeys: _itemKeys,
            onPositionChanged: (key) => context
                .read<QuranCubit>()
                .markLastRead(key ~/ 1000, key % 1000),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return switch (item) {
                  _SurahHeader() => _header(item.surah),
                  _AyahItem() => KeyedSubtree(
                    key: _keyFor(item.ayah.surahId, item.ayah.ayahNumber),
                    child: _lastReadWrap(
                      isLastRead: state.lastRead?.surahId == item.ayah.surahId &&
                          state.lastRead?.ayahNumber == item.ayah.ayahNumber,
                      child: AyahTile(
                        ayah: item.ayah,
                        fontScale: state.arabicFontScale,
                        isBookmarked: state.bookmarks.any(
                          (b) =>
                              b.surahId == item.ayah.surahId &&
                              b.ayahNumber == item.ayah.ayahNumber,
                        ),
                        onToggleBookmark: () => context
                            .read<QuranCubit>()
                            .toggleBookmark(item.ayah.surahId, item.ayah.ayahNumber),
                      ),
                    ),
                  ),
                };
              },
            ),
          );
        },
      ),
    );
  }

  Widget _lastReadWrap({required bool isLastRead, required Widget child}) {
    if (!isLastRead) return child;
    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.gold, width: 3)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.only(left: 4),
      child: child,
    );
  }

  Widget _header(QuranSurah surah) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        '${surah.id}. ${surah.displayName}',
        style: AppTypography.sectionHeader.copyWith(color: AppColors.gold, fontSize: 20),
      ),
    );
  }

  List<_ListItem> _buildItems(List<QuranAyah> ayahs, List<QuranSurah> surahs) {
    final surahsById = {for (final s in surahs) s.id: s};
    final items = <_ListItem>[];
    int? lastSurahId;
    for (final ayah in ayahs) {
      if (ayah.surahId != lastSurahId) {
        lastSurahId = ayah.surahId;
        final surah = surahsById[ayah.surahId] ?? QuranSurah(id: ayah.surahId, ayahCount: 0);
        items.add(_SurahHeader(surah));
      }
      items.add(_AyahItem(ayah));
    }
    return items;
  }
}

sealed class _ListItem {}

class _SurahHeader extends _ListItem {
  _SurahHeader(this.surah);
  final QuranSurah surah;
}

class _AyahItem extends _ListItem {
  _AyahItem(this.ayah);
  final QuranAyah ayah;
}
