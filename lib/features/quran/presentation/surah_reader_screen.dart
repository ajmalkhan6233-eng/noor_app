// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_colors.dart';
import '../logic/quran_cubit/quran_cubit.dart';
import '../logic/quran_cubit/quran_state.dart';
import 'widgets/ayah_tile.dart';

/// Ayah-by-ayah view of one surah, with adjustable Arabic font size
/// (from Settings), bookmarking, and last-read tracking.
class SurahReaderScreen extends StatefulWidget {
  const SurahReaderScreen({super.key, required this.surahId});

  final int surahId;

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<QuranCubit>();
    cubit.openSurah(widget.surahId);
    cubit.markLastRead(widget.surahId, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Surah ${widget.surahId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<QuranCubit, QuranState>(
          builder: (context, state) {
            if (state.currentSurahId != widget.surahId) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              );
            }
            return ListView(
              children: [
                for (final ayah in state.currentAyahs)
                  AyahTile(
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
              ],
            );
          },
        ),
      ),
    );
  }
}
