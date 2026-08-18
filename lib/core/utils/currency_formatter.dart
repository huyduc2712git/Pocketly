import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(
    double amount, {
    String currency = 'VND',
    bool showSymbol = true,
    bool compact = false,
  }) {
    if (currency.toUpperCase() == 'VND') {
      if (compact && amount.abs() >= 1000000) {
        if (amount.abs() >= 1000000000) {
          final val = amount / 1000000000;
          return '${_formatNumber(val, 1)}B${showSymbol ? ' ₫' : ''}';
        }
        final val = amount / 1000000;
        return '${_formatNumber(val, 1)}M${showSymbol ? ' ₫' : ''}';
      }
      final formatter = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: showSymbol ? '₫' : '',
        decimalDigits: 0,
        customPattern: showSymbol ? '#,##0\u00A0\u00A4' : '#,##0',
      );
      return formatter.format(amount).trim();
    } else {
      final formatter = NumberFormat.currency(
        locale: 'en_US',
        symbol: showSymbol ? '\$' : '',
        decimalDigits: 2,
      );
      return formatter.format(amount).trim();
    }
  }

  static String _formatNumber(double number, int decimals) {
    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    }
    return number.toStringAsFixed(decimals);
  }

  static String formatCompact(double amount, {String currency = 'VND'}) {
    return format(amount, currency: currency, compact: true);
  }
}
