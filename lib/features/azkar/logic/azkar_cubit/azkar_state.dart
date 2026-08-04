// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../data/azkar_category.dart';
import '../../data/azkar_import_status.dart';
import '../../data/azkar_item.dart';

class AzkarState extends Equatable {
  const AzkarState({
    this.category = AzkarCategory.morning,
    this.items = const [],
    this.progressByItemId = const {},
    this.isLoading = true,
    this.importStatus,
  });

  final AzkarCategory category;
  final List<AzkarItem> items;
  final Map<int, int> progressByItemId;
  final bool isLoading;

  /// `null` while the initial import check is still running.
  final AzkarImportStatus? importStatus;

  int progressFor(int itemId) => progressByItemId[itemId] ?? 0;

  AzkarState copyWith({
    AzkarCategory? category,
    List<AzkarItem>? items,
    Map<int, int>? progressByItemId,
    bool? isLoading,
    AzkarImportStatus? importStatus,
  }) {
    return AzkarState(
      category: category ?? this.category,
      items: items ?? this.items,
      progressByItemId: progressByItemId ?? this.progressByItemId,
      isLoading: isLoading ?? false,
      importStatus: importStatus ?? this.importStatus,
    );
  }

  @override
  List<Object?> get props => [
    category,
    items,
    progressByItemId,
    isLoading,
    importStatus,
  ];
}
