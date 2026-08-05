// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/prayer_times/data/sri_lanka_district.dart';

void main() {
  group('findSriLankaDistrict', () {
    test('finds an exact match', () {
      final district = findSriLankaDistrict('Kandy');
      expect(district, isNotNull);
      expect(district!.latitude, 7.2906);
      expect(district.longitude, 80.6337);
    });

    test('returns null for null input', () {
      expect(findSriLankaDistrict(null), isNull);
    });

    test('returns null for an unknown name', () {
      expect(findSriLankaDistrict('Atlantis'), isNull);
    });

    test('every district in the list is findable by its own name', () {
      for (final district in sriLankaDistricts) {
        expect(findSriLankaDistrict(district.name), same(district));
      }
    });
  });
}
