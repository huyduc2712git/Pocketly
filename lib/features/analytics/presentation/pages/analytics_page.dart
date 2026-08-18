import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/amount_text.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../domain/entities/analytics_entity.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/cashflow_bar_chart.dart';
import '../widgets/spending_donut_chart.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedAnalyticsPeriodProvider);
    final analyticsAsync = ref.watch(analyticsStreamProvider);
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân Tích Tài Chính'),
      ),
      body: Column(
        children: [
          // Period Selector Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AnalyticsPeriod.values.map((period) {
                  final isSelected = selectedPeriod == period;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: GestureDetector(
                      onTap: () {
                        ref.read(selectedAnalyticsPeriodProvider.notifier).state = period;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                        ),
                        child: Text(
                          period.displayName,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Analytics Content
          Expanded(
            child: analyticsAsync.when(
              loading: () => const AppLoading(message: 'Đang phân tích số liệu tài chính...'),
              error: (err, _) => Center(child: Text('Lỗi: $err')),
              data: (summary) {
                if (summary.totalExpense <= 0 && summary.totalIncome <= 0) {
                  return AppEmptyState(
                    title: 'Chưa có dữ liệu phân tích',
                    message: 'Hãy ghi nhận các khoản thu chi trong "${selectedPeriod.displayName}" để Finly phân tích cho bạn.',
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Financial Health Summary Card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildSummaryMetric(
                                  label: 'Tổng thu',
                                  amount: summary.totalIncome,
                                  color: AppColors.income,
                                  icon: Icons.arrow_downward_rounded,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: _buildSummaryMetric(
                                  label: 'Tổng chi',
                                  amount: summary.totalExpense,
                                  color: AppColors.expense,
                                  icon: Icons.arrow_upward_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const Divider(height: 1),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tiết kiệm ròng (Net Savings)',
                                    style: TextStyle(fontSize: 12, color: AppColors.darkTextSecondary),
                                  ),
                                  const SizedBox(height: 2),
                                  AmountText(
                                    amount: summary.netSavings,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: summary.netSavings >= 0 ? AppColors.income : AppColors.error,
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: summary.savingsRate >= 20
                                      ? AppColors.income.withValues(alpha: 0.15)
                                      : AppColors.warning.withValues(alpha: 0.15),
                                  borderRadius: AppRadius.borderSm,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Tỷ lệ tiết kiệm', style: TextStyle(fontSize: 10, color: AppColors.darkTextMuted)),
                                    Text(
                                      '${summary.savingsRate.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: summary.savingsRate >= 20 ? AppColors.income : AppColors.warning,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Spending by Category Donut Chart Card
                    if (summary.totalExpense > 0) ...[
                      const Text(
                        'Phân bổ chi tiêu theo danh mục',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkTextPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            SpendingDonutChart(
                              categories: summary.topCategories,
                              totalExpense: summary.totalExpense,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            ...summary.topCategories.map((cat) {
                              final color = IconHelper.getColor(cat.categoryColor);
                              final icon = IconHelper.getIcon(cat.categoryIcon);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.15),
                                        borderRadius: AppRadius.borderSm,
                                      ),
                                      child: Icon(icon, color: color, size: 18),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cat.categoryName,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            '${cat.transactionCount} giao dịch',
                                            style: const TextStyle(fontSize: 11, color: AppColors.darkTextSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        AmountText(
                                          amount: cat.amount,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        Text(
                                          '${cat.percentage.toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Cashflow Trend Card
                    const Text(
                      'Xu hướng dòng tiền (Thu vs Chi)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkTextPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: CashflowBarChart(points: summary.cashflowTrend),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric({
    required String label,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.darkTextSecondary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 4),
        AmountText(
          amount: amount,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ],
    );
  }
}
