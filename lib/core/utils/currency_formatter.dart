import 'package:flutter/services.dart';
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

  /// Formats raw numeric value into dot-separated input string (e.g. 2000000 -> "2.000.000")
  static String formatInput(double amount) {
    if (amount <= 0) return '';
    final formatter = NumberFormat('#,##0', 'vi_VN');
    return formatter.format(amount).replaceAll(',', '.');
  }

  /// Parses dot-separated or comma-separated amount string into numeric double (e.g. "2.000.000" -> 2000000.0)
  static double parse(String? text) {
    if (text == null || text.trim().isEmpty) return 0.0;
    final cleanDigits = text.replaceAll(RegExp(r'[^0-9]'), '');
    return double.tryParse(cleanDigits) ?? 0.0;
  }
}

/// Real-time TextInputFormatter that dynamically formats currency digits with dots (e.g. 2000000 -> 2.000.000)
class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0', 'vi_VN');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Keep only numeric digits
    final cleanDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanDigits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final number = double.tryParse(cleanDigits);
    if (number == null) {
      return oldValue;
    }

    // Format with Vietnamese dot separator: e.g. 2.000.000
    final formatted = _formatter.format(number).replaceAll(',', '.');

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
