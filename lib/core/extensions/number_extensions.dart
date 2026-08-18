import '../utils/currency_formatter.dart';

extension NumberExtensions on num {
  String toCurrency({
    String currency = 'VND',
    bool showSymbol = true,
    bool compact = false,
  }) {
    return CurrencyFormatter.format(
      toDouble(),
      currency: currency,
      showSymbol: showSymbol,
      compact: compact,
    );
  }

  String toCompactCurrency({String currency = 'VND'}) {
    return CurrencyFormatter.formatCompact(toDouble(), currency: currency);
  }
}
