import 'package:flutter/material.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_spacing.dart';
import 'package:finly/shared/widgets/amount_text.dart';
import '../controllers/dashboard_controller.dart';

class QuickMetricsRow extends StatelessWidget {
  final DashboardSummary summary;

  const QuickMetricsRow({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final progressFraction = (summary.budgetProgressPercentage / 100).clamp(0.0, 1.0);

    return Row(
      children: [
        // Remaining Budget Metric
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFF161F30),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Ngân sách còn lại',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.pie_chart_outline_rounded,
                        size: 15,
                        color: summary.remainingBudget >= 0
                            ? AppColors.primaryLight
                            : AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                AmountText(
                  amount: summary.remainingBudget,
                  currency: summary.currency,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: summary.remainingBudget >= 0
                      ? const Color(0xFF34D399)
                      : AppColors.error,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        // Budget Usage Progress Metric
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFF161F30),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tiến độ sử dụng',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkTextSecondary,
                      ),
                    ),
                    Text(
                      '${summary.budgetProgressPercentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: summary.budgetProgressPercentage > 100
                            ? AppColors.error
                            : (summary.budgetProgressPercentage >= 80
                                ? AppColors.warning
                                : AppColors.primaryLight),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Glowing Progress Bar
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: progressFraction,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: summary.budgetProgressPercentage > 100
                                  ? [AppColors.error, const Color(0xFFF43F5E)]
                                  : [AppColors.primary, AppColors.cyan],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: (summary.budgetProgressPercentage > 100
                                        ? AppColors.error
                                        : AppColors.primary)
                                    .withValues(alpha: 0.4),
                                blurRadius: 4,
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
      ],
    );
  }
}
