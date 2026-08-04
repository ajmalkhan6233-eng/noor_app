// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/zakat/data/zakat_calculator.dart';

void main() {
  group('ZakatCalculator.calculate', () {
    test('net wealth sums all categories and subtracts liabilities', () {
      const inputs = ZakatInputs(
        goldGrams: 10,
        goldPricePerGram: 80,
        silverGrams: 100,
        silverPricePerGram: 1,
        cash: 500,
        receivables: 200,
        businessInventoryValue: 300,
        liabilities: 100,
      );
      final result = ZakatCalculator.calculate(inputs);
      // gold 800 + silver 100 + cash 500 + receivables 200 + inventory 300 - liabilities 100
      expect(result.netWealth, 1800);
    });

    test('nisab threshold uses the lower of gold and silver values', () {
      const inputs = ZakatInputs(goldPricePerGram: 80, silverPricePerGram: 1);
      final result = ZakatCalculator.calculate(inputs);
      // gold nisab = 85*80=6800, silver nisab = 595*1=595 -> lower is silver
      expect(result.nisabThreshold, 595);
    });

    test('falls back to whichever metal price was actually entered', () {
      const inputs = ZakatInputs(silverPricePerGram: 1);
      final result = ZakatCalculator.calculate(inputs);
      expect(result.nisabThreshold, 595);
    });

    test('nisab threshold is zero when no prices are entered', () {
      final result = ZakatCalculator.calculate(const ZakatInputs());
      expect(result.nisabThreshold, 0);
      expect(result.nisabMet, isFalse);
      expect(result.zakatDue, 0);
    });

    test('zakat due is 2.5% of net wealth once nisab is met', () {
      const inputs = ZakatInputs(silverPricePerGram: 1, cash: 1000);
      final result = ZakatCalculator.calculate(inputs);
      expect(result.nisabMet, isTrue);
      expect(result.zakatDue, closeTo(25, 0.0001));
    });

    test('zakat is not due below nisab even with wealth present', () {
      const inputs = ZakatInputs(silverPricePerGram: 1, cash: 100);
      final result = ZakatCalculator.calculate(inputs);
      expect(result.nisabMet, isFalse);
      expect(result.zakatDue, 0);
    });

    test('liabilities can bring net wealth below nisab', () {
      const inputs = ZakatInputs(
        silverPricePerGram: 1,
        cash: 1000,
        liabilities: 900,
      );
      final result = ZakatCalculator.calculate(inputs);
      expect(result.netWealth, 100);
      expect(result.nisabMet, isFalse);
    });
  });
}
