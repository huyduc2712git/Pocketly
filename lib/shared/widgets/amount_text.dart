import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';

enum AmountType { normal, income, expense, transfer }

class AmountText extends StatelessWidget {
  final double amount;
  final String currency;
  final AmountType type;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showSign;
  final bool compact;
  final Color? color;

  const AmountText({
    super.key,
    required this.amount,
    this.currency = 'VND',
    this.type = AmountType.normal,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w600,
    this.showSign = false,
    this.compact = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color textColor;
    if (color != null) {
      textColor = color!;
    } else {
      switch (type) {
        case AmountType.income:
          textColor = AppColors.income;
          break;
        case AmountType.expense:
          textColor = AppColors.expense;
          break;
        case AmountType.transfer:
          textColor = AppColors.transfer;
          break;
        case AmountType.normal:
          textColor = isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary;
          break;
      }
    }

    String prefix = '';
    if (showSign) {
      if (type == AmountType.income) {
        prefix = '+';
      } else if (type == AmountType.expense) {
        prefix = '-';
      }
    }

    final formattedAmount = CurrencyFormatter.format(
      amount,
      currency: currency,
      compact: compact,
    );

    return Text(
      '$prefix$formattedAmount',
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: -0.3,
      ),
    );
  }
}
