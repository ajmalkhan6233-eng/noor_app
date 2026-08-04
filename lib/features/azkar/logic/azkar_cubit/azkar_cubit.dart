// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/azkar_category.dart';
import '../../data/azkar_import_service.dart';
import '../../data/azkar_repository.dart';
import 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  AzkarCubit({AzkarRepository? repository, AzkarImportService? importService})
    : _repository = repository ?? AzkarRepository(),
      _importService = importService ?? AzkarImportService(),
      super(const AzkarState());

  final AzkarRepository _repository;
  final AzkarImportService _importService;

  Future<void> init() async {
    final status = await _importService.ensureImported();
    emit(state.copyWith(importStatus: status));
    await selectCategory(AzkarCategory.morning);
  }

  Future<void> selectCategory(AzkarCategory category) async {
    emit(state.copyWith(category: category, isLoading: true));
    final items = await _repository.itemsForCategory(category);

    final progress = <int, int>{};
    for (final item in items) {
      progress[item.id] = await _repository.progressFor(item.id);
    }

    emit(
      state.copyWith(
        category: category,
        items: items,
        progressByItemId: progress,
        isLoading: false,
      ),
    );
  }

  Future<void> increment(int itemId) async {
    final next = await _repository.incrementProgress(itemId);
    emit(
      state.copyWith(
        progressByItemId: {...state.progressByItemId, itemId: next},
      ),
    );
  }

  Future<void> reset(int itemId) async {
    await _repository.resetProgress(itemId);
    emit(
      state.copyWith(
        progressByItemId: {...state.progressByItemId, itemId: 0},
      ),
    );
  }
}
