// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../data/quran_ayah.dart';
import '../../data/quran_bookmark.dart';
import '../../data/quran_import_status.dart';
import '../../data/quran_surah.dart';

class QuranState extends Equatable {
  const QuranState({
    this.importStatus,
    this.surahs = const [],
    this.bookmarks = const [],
    this.lastRead,
    this.searchQuery = '',
    this.searchResults = const [],
    this.isLoading = true,
    this.currentSurahId,
    this.currentAyahs = const [],
    this.arabicFontScale = 1.0,
    this.fullQuranAyahs,
  });

  /// `null` while the initial import check is still running.
  final QuranImportStatus? importStatus;
  final List<QuranSurah> surahs;
  final List<QuranBookmark> bookmarks;
  final QuranReadingPosition? lastRead;
  final String searchQuery;
  final List<QuranAyah> searchResults;
  final bool isLoading;

  /// Surah currently open in the reader, and its ayahs (empty until
  /// [currentSurahId] is set).
  final int? currentSurahId;
  final List<QuranAyah> currentAyahs;
  final double arabicFontScale;

  /// `null` until the continuous full-Quran view has been opened once
  /// — loaded on demand rather than eagerly on [QuranCubit.init], so
  /// opening the per-surah index (the common case) doesn't pay for it.
  final List<QuranAyah>? fullQuranAyahs;

  bool get isImported => importStatus is QuranImported;

  QuranState copyWith({
    QuranImportStatus? importStatus,
    List<QuranSurah>? surahs,
    List<QuranBookmark>? bookmarks,
    QuranReadingPosition? lastRead,
    String? searchQuery,
    List<QuranAyah>? searchResults,
    bool? isLoading,
    int? currentSurahId,
    List<QuranAyah>? currentAyahs,
    double? arabicFontScale,
    List<QuranAyah>? fullQuranAyahs,
  }) {
    return QuranState(
      importStatus: importStatus ?? this.importStatus,
      surahs: surahs ?? this.surahs,
      bookmarks: bookmarks ?? this.bookmarks,
      lastRead: lastRead ?? this.lastRead,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? false,
      currentSurahId: currentSurahId ?? this.currentSurahId,
      currentAyahs: currentAyahs ?? this.currentAyahs,
      arabicFontScale: arabicFontScale ?? this.arabicFontScale,
      fullQuranAyahs: fullQuranAyahs ?? this.fullQuranAyahs,
    );
  }

  @override
  List<Object?> get props => [
    importStatus,
    surahs,
    bookmarks,
    lastRead,
    searchQuery,
    searchResults,
    isLoading,
    currentSurahId,
    currentAyahs,
    arabicFontScale,
    fullQuranAyahs,
  ];
}
