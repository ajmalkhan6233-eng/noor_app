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
    this.bookmarkedItemIds = const {},
    this.bookmarkedItems = const [],
  });

  final AzkarCategory category;
  final List<AzkarItem> items;
  final Map<int, int> progressByItemId;
  final bool isLoading;

  /// `null` while the initial import check is still running.
  final AzkarImportStatus? importStatus;

  /// Every bookmarked item's id, regardless of category — drives the
  /// bookmark icon on every AzkarItemTile, wherever it's shown.
  final Set<int> bookmarkedItemIds;

  /// Populated by AzkarCubit.loadBookmarks() for the bookmarks screen —
  /// spans every category, unlike [items] which is one category only.
  final List<AzkarItem> bookmarkedItems;

  int progressFor(int itemId) => progressByItemId[itemId] ?? 0;

  bool isBookmarked(int itemId) => bookmarkedItemIds.contains(itemId);

  AzkarState copyWith({
    AzkarCategory? category,
    List<AzkarItem>? items,
    Map<int, int>? progressByItemId,
    bool? isLoading,
    AzkarImportStatus? importStatus,
    Set<int>? bookmarkedItemIds,
    List<AzkarItem>? bookmarkedItems,
  }) {
    return AzkarState(
      category: category ?? this.category,
      items: items ?? this.items,
      progressByItemId: progressByItemId ?? this.progressByItemId,
      isLoading: isLoading ?? false,
      importStatus: importStatus ?? this.importStatus,
      bookmarkedItemIds: bookmarkedItemIds ?? this.bookmarkedItemIds,
      bookmarkedItems: bookmarkedItems ?? this.bookmarkedItems,
    );
  }

  @override
  List<Object?> get props => [
    category,
    items,
    progressByItemId,
    isLoading,
    importStatus,
    bookmarkedItemIds,
    bookmarkedItems,
  ];
}
