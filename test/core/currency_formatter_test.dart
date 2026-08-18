import 'package:finly/core/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyFormatter tests', () {
    test('Format VND with standard formatting', () {
      final formatted = CurrencyFormatter.format(350000);
      expect(
        formatted.contains('350.000') || formatted.contains('350,000'),
        isTrue,
      );
      expect(formatted.contains('₫'), isTrue);
    });

    test('Format VND without symbol', () {
      final formatted = CurrencyFormatter.format(350000, showSymbol: false);
      expect(
        formatted.contains('350.000') || formatted.contains('350,000'),
        isTrue,
      );
      expect(formatted.contains('₫'), isFalse);
    });

    test('Format VND compact with millions and billions', () {
      final compactM = CurrencyFormatter.formatCompact(3500000);
      expect(compactM, contains('3.5M'));

      final compactB = CurrencyFormatter.formatCompact(2000000000);
      expect(compactB, contains('2B'));
    });

    test('Format USD with dollar symbol and two decimals', () {
      final formatted = CurrencyFormatter.format(1234.56, currency: 'USD');
      expect(formatted, contains('\$'));
      expect(formatted, contains('1,234.56'));
    });
  });
}
