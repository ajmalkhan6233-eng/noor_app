// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../settings/data/settings_repository.dart';
import '../../data/quran_import_service.dart';
import '../../data/quran_import_status.dart';
import '../../data/quran_repository.dart';
import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit({
    QuranRepository? repository,
    QuranImportService? importService,
    SettingsRepository? settingsRepository,
  }) : _repository = repository ?? QuranRepository(),
       _importService = importService ?? QuranImportService(),
       _settingsRepository = settingsRepository ?? SettingsRepository(),
       super(const QuranState());

  final QuranRepository _repository;
  final QuranImportService _importService;
  final SettingsRepository _settingsRepository;

  Future<void> init() async {
    final appSettings = await _settingsRepository.load();
    final status = await _importService.ensureImported(
      onProgress: (progress) {
        if (!isClosed) {
          emit(state.copyWith(importStatus: QuranImporting(progress)));
        }
      },
    );
    if (status is! QuranImported) {
      emit(
        state.copyWith(
          importStatus: status,
          arabicFontScale: appSettings.arabicFontScale,
          isLoading: false,
        ),
      );
      return;
    }

    final surahs = await _repository.surahs();
    final bookmarks = await _repository.bookmarks();
    final lastRead = await _repository.lastRead();

    emit(
      state.copyWith(
        importStatus: status,
        surahs: surahs,
        bookmarks: bookmarks,
        lastRead: lastRead,
        arabicFontScale: appSettings.arabicFontScale,
        isLoading: false,
      ),
    );
  }

  Future<void> openSurah(int surahId) async {
    final ayahs = await _repository.ayahsForSurah(surahId);
    emit(state.copyWith(currentSurahId: surahId, currentAyahs: ayahs));
  }

  Future<void> search(String query) async {
    emit(state.copyWith(searchQuery: query));
    final results = await _repository.search(query);
    emit(state.copyWith(searchResults: results));
  }

  Future<void> toggleBookmark(int surahId, int ayahNumber) async {
    final existing = state.bookmarks.where(
      (b) => b.surahId == surahId && b.ayahNumber == ayahNumber,
    );
    if (existing.isEmpty) {
      await _repository.addBookmark(surahId, ayahNumber);
    } else {
      await _repository.removeBookmark(existing.first.id);
    }
    emit(state.copyWith(bookmarks: await _repository.bookmarks()));
  }

  Future<void> markLastRead(int surahId, int ayahNumber) async {
    await _repository.setLastRead(surahId, ayahNumber);
    emit(state.copyWith(lastRead: await _repository.lastRead()));
  }
}
