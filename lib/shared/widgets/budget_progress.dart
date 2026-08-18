import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import 'amount_text.dart';

class BudgetProgress extends StatelessWidget {
  final String categoryName;
  final IconData? icon;
  final Color? categoryColor;
  final double spent;
  final double budgetAmount;
  final String currency;
  final double? forecastAmount;
  final VoidCallback? onTap;

  const BudgetProgress({
    super.key,
    required this.categoryName,
    this.icon,
    this.categoryColor,
    required this.spent,
    required this.budgetAmount,
    this.currency = 'VND',
    this.forecastAmount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ratio = budgetAmount > 0 ? (spent / budgetAmount).clamp(0.0, 1.0) : 0.0;
    final percent = budgetAmount > 0 ? ((spent / budgetAmount) * 100).toInt() : 0;
    final remaining = (budgetAmount - spent).clamp(0.0, double.infinity);

    Color progressColor = AppColors.primary;
    if (percent > 100) {
      progressColor = AppColors.error;
    } else if (percent >= 80) {
      progressColor = AppColors.warning;
    }

    final isExceeded = spent > budgetAmount;
    final isForecastExceeded = forecastAmount != null && forecastAmount! > budgetAmount;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (categoryColor ?? AppColors.primary).withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderSm,
                      ),
                      child: Icon(
                        icon,
                        size: 16,
                        color: categoryColor ?? AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Expanded(
                    child: Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AmountText(
                    amount: spent,
                    currency: currency,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  Text(
                    ' / ',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                  ),
                  AmountText(
                    amount: budgetAmount,
                    currency: currency,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              // Progress Bar
              Stack(
                children: [
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightCardElevated,
                      borderRadius: AppRadius.borderFull,
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 8,
                        width: constraints.maxWidth * ratio,
                        decoration: BoxDecoration(
                          color: progressColor,
                          borderRadius: AppRadius.borderFull,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$percent% đã chi',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: progressColor,
                    ),
                  ),
                  if (isExceeded)
                    const Text(
                      'Vượt ngân sách!',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    )
                  else if (isForecastExceeded)
                    const Text(
                      'Dự báo có thể vượt',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.warning,
                      ),
                    )
                  else
                    Text(
                      'Còn lại ${remaining.toInt()} $currency',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
