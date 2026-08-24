// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// One continuous, scrollable column covering the entire Quran —
// requested alongside the existing per-surah breakdown (2026-08-24
// live-device review: "I need one column with the entire Quran").
// All ~6,236 ayahs load once (see QuranCubit.loadFullQuran), but
// ListView.builder only ever builds the tiles actually on screen, so
// this stays cheap to render regardless of length.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../data/quran_ayah.dart';
import '../data/quran_surah.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'widgets/ayah_tile.dart';

class FullQuranScreen extends StatefulWidget {
  const FullQuranScreen({super.key});

  @override
  State<FullQuranScreen> createState() => _FullQuranScreenState();
}

class _FullQuranScreenState extends State<FullQuranScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().loadFullQuran();
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
          final items = _buildItems(ayahs, state.surahs);
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return switch (item) {
                _SurahHeader() => _header(item.surah),
                _AyahItem() => AyahTile(
                  ayah: item.ayah,
                  fontScale: state.arabicFontScale,
                  isBookmarked: state.bookmarks.any(
                    (b) => b.surahId == item.ayah.surahId && b.ayahNumber == item.ayah.ayahNumber,
                  ),
                  onToggleBookmark: () => context
                      .read<QuranCubit>()
                      .toggleBookmark(item.ayah.surahId, item.ayah.ayahNumber),
                ),
              };
            },
          );
        },
      ),
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
