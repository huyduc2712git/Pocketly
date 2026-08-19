import 'package:flutter/material.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_spacing.dart';
import 'package:finly/shared/widgets/amount_text.dart';
import 'package:finly/shared/widgets/app_3d_icon.dart';

class BudgetProgress extends StatelessWidget {
  final String categoryName;
  final IconData? icon;
  final String? iconAsset;
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
    this.iconAsset,
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
    final ratio = budgetAmount > 0
        ? (spent / budgetAmount).clamp(0.0, 1.0)
        : 0.0;
    final percent = budgetAmount > 0
        ? ((spent / budgetAmount) * 100).toInt()
        : 0;
    final remaining = (budgetAmount - spent).clamp(0.0, double.infinity);

    Color progressColor = AppColors.primary;
    if (percent > 100) {
      progressColor = AppColors.error;
    } else if (percent >= 80) {
      progressColor = AppColors.warning;
    }

    final isExceeded = spent > budgetAmount;
    final resolvedColor = categoryColor ?? AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm - 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Squircle Category Icon with glow
                  if (iconAsset != null || icon != null) ...[
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            resolvedColor.withValues(alpha: 0.25),
                            resolvedColor.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: resolvedColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: iconAsset != null
                            ? App3DIcon(assetPath: iconAsset!, size: 24)
                            : Icon(
                                icon,
                                size: 18,
                                color: resolvedColor,
                              ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  // Category Title & Subtext
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isExceeded
                              ? 'Vượt hạn mức'
                              : 'Còn lại ${(remaining / 1000).toStringAsFixed(0)}k $currency',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isExceeded
                                ? AppColors.error
                                : (isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spent vs Budget Amounts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AmountText(
                            amount: spent,
                            currency: currency,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isExceeded
                                ? AppColors.error
                                : (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary),
                          ),
                          Text(
                            ' / ${(budgetAmount / 1000000).toStringAsFixed(1)}M',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: progressColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$percent%',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: progressColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs + 2),

              // Neon Gradient Progress Track
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: ratio,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              progressColor.withValues(alpha: 0.7),
                              progressColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: progressColor.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
