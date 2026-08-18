import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/amount_text.dart';
import '../../../../shared/widgets/app_card.dart';
import '../controllers/dashboard_controller.dart';

class QuickMetricsRow extends StatelessWidget {
  final DashboardSummary summary;

  const QuickMetricsRow({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Remaining Budget Metric
        Expanded(
          child: AppCard(
            padding: AppSpacing.compactCardPadding,
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
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.pie_chart_outline_rounded,
                      size: 16,
                      color: summary.remainingBudget >= 0
                          ? AppColors.primaryLight
                          : AppColors.error,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                AmountText(
                  amount: summary.remainingBudget,
                  currency: summary.currency,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: summary.remainingBudget >= 0
                      ? AppColors.income
                      : AppColors.error,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Budget Progress Metric
        Expanded(
          child: AppCard(
            padding: AppSpacing.compactCardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Tiến độ sử dụng',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.trending_up_rounded,
                      size: 16,
                      color: AppColors.warning,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${summary.budgetProgressPercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
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
