// Bismillahir Rahmanir Raheem — watermark: ALLAH

import 'package:flutter_test/flutter_test.dart';
import 'package:noor/features/zakat/data/zakat_amount_parser.dart';

void main() {
  test('plain and decimal numbers', () {
    expect(parseZakatAmount('1500'), 1500);
    expect(parseZakatAmount('12.5'), 12.5);
  });
  test('Sri Lankan thousands separators are accepted', () {
    expect(parseZakatAmount('150,000'), 150000);
    expect(parseZakatAmount('1,250,000.50'), 1250000.50);
    expect(parseZakatAmount(' 2 500 '), 2500);
  });
  test('currency prefixes are ignored', () {
    expect(parseZakatAmount('Rs. 5,000'), 5000);
    expect(parseZakatAmount('LKR 300'), 300);
    expect(parseZakatAmount('rs800'), 800);
  });
  test('negative, empty and junk become 0', () {
    expect(parseZakatAmount('-500'), 0);
    expect(parseZakatAmount(''), 0);
    expect(parseZakatAmount('abc'), 0);
    expect(parseZakatAmount('1e400'), 0);
  });
}
