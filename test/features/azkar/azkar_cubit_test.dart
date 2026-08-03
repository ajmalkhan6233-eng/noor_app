// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/azkar/data/azkar_category.dart';
import 'package:noor/features/azkar/data/azkar_item.dart';
import 'package:noor/features/azkar/data/azkar_repository.dart';
import 'package:noor/features/azkar/logic/azkar_cubit/azkar_cubit.dart';

/// Overrides every public method so the real `sqflite_sqlcipher`
/// calls (and the platform channel they need) are never reached.
class _FakeAzkarRepository extends AzkarRepository {
  _FakeAzkarRepository(this._itemsByCategory);

  final Map<AzkarCategory, List<AzkarItem>> _itemsByCategory;
  final Map<int, int> _progress = {};

  @override
  Future<List<AzkarItem>> itemsForCategory(AzkarCategory category) async =>
      _itemsByCategory[category] ?? [];

  @override
  Future<int> progressFor(int itemId) async => _progress[itemId] ?? 0;

  @override
  Future<int> incrementProgress(int itemId) async {
    final next = (_progress[itemId] ?? 0) + 1;
    _progress[itemId] = next;
    return next;
  }

  @override
  Future<void> resetProgress(int itemId) async => _progress[itemId] = 0;
}

const _item = AzkarItem(
  id: 1,
  arabicText: 'placeholder',
  repeatCount: 3,
  source: 'test fixture',
);

void main() {
  group('AzkarCubit', () {
    test('selectCategory with no items surfaces an empty list', () async {
      final cubit = AzkarCubit(repository: _FakeAzkarRepository({}));
      await cubit.selectCategory(AzkarCategory.morning);

      expect(cubit.state.items, isEmpty);
      expect(cubit.state.isLoading, isFalse);
      await cubit.close();
    });

    test('selectCategory loads items and their saved progress', () async {
      final repository = _FakeAzkarRepository({
        AzkarCategory.evening: [_item],
      });
      final cubit = AzkarCubit(repository: repository);

      await cubit.selectCategory(AzkarCategory.evening);

      expect(cubit.state.items, [_item]);
      expect(cubit.state.progressFor(_item.id), 0);
      await cubit.close();
    });

    test('increment advances the count for that item only', () async {
      final repository = _FakeAzkarRepository({
        AzkarCategory.evening: [_item],
      });
      final cubit = AzkarCubit(repository: repository);
      await cubit.selectCategory(AzkarCategory.evening);

      await cubit.increment(_item.id);
      await cubit.increment(_item.id);

      expect(cubit.state.progressFor(_item.id), 2);
      expect(cubit.state.progressFor(999), 0);
      await cubit.close();
    });

    test('reset zeroes the count', () async {
      final repository = _FakeAzkarRepository({
        AzkarCategory.evening: [_item],
      });
      final cubit = AzkarCubit(repository: repository);
      await cubit.selectCategory(AzkarCategory.evening);
      await cubit.increment(_item.id);

      await cubit.reset(_item.id);

      expect(cubit.state.progressFor(_item.id), 0);
      await cubit.close();
    });
  });
}
