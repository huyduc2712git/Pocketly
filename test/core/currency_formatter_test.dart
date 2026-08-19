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

    test('CurrencyInputFormatter formats typed digits into dot-separated currency', () {
      final formatter = CurrencyInputFormatter();

      final result1 = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '2000000'),
      );
      expect(result1.text, equals('2.000.000'));

      final result2 = formatter.formatEditUpdate(
        const TextEditingValue(text: '2.000.000'),
        const TextEditingValue(text: '2.000.0000'),
      );
      expect(result2.text, equals('20.000.000'));

      final result3 = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '50000'),
      );
      expect(result3.text, equals('50.000'));
    });

    test('CurrencyFormatter.parse safely parses formatted string to double', () {
      expect(CurrencyFormatter.parse('2.000.000'), equals(2000000.0));
      expect(CurrencyFormatter.parse('2,000,000 ₫'), equals(2000000.0));
      expect(CurrencyFormatter.parse('50.000'), equals(50000.0));
      expect(CurrencyFormatter.parse(''), equals(0.0));
      expect(CurrencyFormatter.parse(null), equals(0.0));
    });

    test('CurrencyFormatter.formatInput formats numbers into dot-separated strings', () {
      expect(CurrencyFormatter.formatInput(2000000), equals('2.000.000'));
      expect(CurrencyFormatter.formatInput(150000), equals('150.000'));
      expect(CurrencyFormatter.formatInput(0), equals(''));
    });
  });
}
