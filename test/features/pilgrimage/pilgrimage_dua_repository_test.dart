// Bismillahir Rahmanir Raheem — watermark: ALLAH
//
// Against the real bundled asset, loaded via rootBundle same as
// production.

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/pilgrimage/data/pilgrimage_dua_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('forKey returns the tawaf dua with its repeat count and source', () async {
    const repository = PilgrimageDuaRepository();
    final dua = await repository.forKey('tawaf');

    expect(dua, isNotNull);
    expect(dua!.arabicText, contains('رَبَّنَا'));
    expect(dua.repeatCount, 1);
    expect(dua.source, isNotEmpty);
  });

  test('forKey returns the sai dhikr with repeat count 3', () async {
    const repository = PilgrimageDuaRepository();
    final dua = await repository.forKey('sai');

    expect(dua, isNotNull);
    expect(dua!.repeatCount, 3);
  });

  test('forKey returns null for an unknown key', () async {
    const repository = PilgrimageDuaRepository();
    final dua = await repository.forKey('nonexistent');

    expect(dua, isNull);
  });
}
