// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:equatable/equatable.dart';

import '../../data/azkar_category.dart';
import '../../data/azkar_item.dart';

class AzkarState extends Equatable {
  const AzkarState({
    this.category = AzkarCategory.morning,
    this.items = const [],
    this.progressByItemId = const {},
    this.isLoading = true,
  });

  final AzkarCategory category;
  final List<AzkarItem> items;
  final Map<int, int> progressByItemId;
  final bool isLoading;

  int progressFor(int itemId) => progressByItemId[itemId] ?? 0;

  AzkarState copyWith({
    AzkarCategory? category,
    List<AzkarItem>? items,
    Map<int, int>? progressByItemId,
    bool? isLoading,
  }) {
    return AzkarState(
      category: category ?? this.category,
      items: items ?? this.items,
      progressByItemId: progressByItemId ?? this.progressByItemId,
      isLoading: isLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [category, items, progressByItemId, isLoading];
}
