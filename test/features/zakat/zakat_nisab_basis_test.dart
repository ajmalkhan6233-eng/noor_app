// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/zakat/data/zakat_calculator.dart';

void main() {
  const base = ZakatInputs(goldPricePerGram: 30000, silverPricePerGram: 400, cash: 1000000);

  test('lowest (default) uses the cheaper silver nisab', () {
    final r = ZakatCalculator.calculate(base);
    expect(r.nisabThreshold, closeTo(612.36 * 400, 1e-6));
    expect(r.nisabMet, isTrue);
  });

  test('gold basis uses the gold nisab only', () {
    final r = ZakatCalculator.calculate(base.copyWith(nisabBasis: NisabBasis.gold));
    expect(r.nisabThreshold, closeTo(87.48 * 30000, 1e-6));
    expect(r.nisabMet, isFalse); // 1,000,000 < 2,624,400
    expect(r.zakatDue, 0);
  });

  test('silver basis uses the silver nisab only', () {
    final r = ZakatCalculator.calculate(base.copyWith(nisabBasis: NisabBasis.silver));
    expect(r.nisabThreshold, closeTo(612.36 * 400, 1e-6));
    expect(r.zakatDue, closeTo(25000, 1e-6));
  });

  test('gold grams without a gold price raise the heads-up', () {
    final r = ZakatCalculator.calculate(const ZakatInputs(goldGrams: 50, silverPricePerGram: 400));
    expect(r.missingGoldPrice, isTrue);
    expect(r.missingSilverPrice, isFalse);
  });
}
