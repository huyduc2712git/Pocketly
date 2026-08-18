import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/amount_text.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/budget_progress.dart';
import '../controllers/budget_controller.dart';
import '../widgets/set_budget_sheet.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthState = ref.watch(selectedBudgetMonthProvider);
    final budgetAsync = ref.watch(currentBudgetStreamProvider);
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Ngân Sách'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Thiết lập ngân sách',
            onPressed: () {
              final existing = budgetAsync.valueOrNull;
              SetBudgetSheet.show(
                context,
                month: monthState.month,
                year: monthState.year,
                existingBudget: existing,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Month Selector Header
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () {
                    ref.read(selectedBudgetMonthProvider.notifier).state = monthState.prev();
                  },
                ),
                Text(
                  'Tháng ${monthState.month}, ${monthState.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () {
                    ref.read(selectedBudgetMonthProvider.notifier).state = monthState.next();
                  },
                ),
              ],
            ),
          ),

          // Budget Content
          Expanded(
            child: budgetAsync.when(
              loading: () => const AppLoading(message: 'Đang tải thông tin ngân sách...'),
              error: (err, _) => Center(child: Text('Lỗi: $err')),
              data: (budget) {
                if (budget == null || budget.totalLimit <= 0) {
                  return AppEmptyState(
                    title: 'Chưa thiết lập ngân sách',
                    message: 'Đặt hạn mức chi tiêu cho Tháng ${monthState.month}/${monthState.year} để kiểm soát tài chính tốt hơn.',
                    actionText: 'Thiết lập ngân sách ngay',
                    onActionPressed: () => SetBudgetSheet.show(
                      context,
                      month: monthState.month,
                      year: monthState.year,
                    ),
                  );
                }

                final forecast = budget.forecast;

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // Main Budget Progress Card
                    AppCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Hạn mức tháng này',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.darkTextSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  AmountText(
                                    amount: budget.totalLimit,
                                    currency: budget.currency,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryLight,
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: budget.isExceeded
                                      ? AppColors.error.withValues(alpha: 0.15)
                                      : budget.isWarning
                                          ? AppColors.warning.withValues(alpha: 0.15)
                                          : AppColors.income.withValues(alpha: 0.15),
                                  borderRadius: AppRadius.borderSm,
                                ),
                                child: Text(
                                  '${budget.progressPercentage.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: budget.isExceeded
                                        ? AppColors.error
                                        : budget.isWarning
                                            ? AppColors.warning
                                            : AppColors.income,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: (budget.progressPercentage / 100).clamp(0.0, 1.0),
                              minHeight: 10,
                              backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                budget.isExceeded
                                    ? AppColors.error
                                    : budget.isWarning
                                        ? AppColors.warning
                                        : AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMetricItem('Đã chi', budget.spentAmount, AppColors.expense),
                              _buildMetricItem('Còn lại', budget.remainingBudget, budget.remainingBudget >= 0 ? AppColors.income : AppColors.error),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Forecast Intelligence Banner
                    if (forecast != null) ...[
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        backgroundColor: forecast.isOverBudgetRisk
                            ? AppColors.error.withValues(alpha: 0.1)
                            : AppColors.primary.withValues(alpha: 0.1),
                        border: Border.all(
                          color: forecast.isOverBudgetRisk
                              ? AppColors.error.withValues(alpha: 0.4)
                              : AppColors.primary.withValues(alpha: 0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  forecast.isOverBudgetRisk
                                      ? Icons.warning_amber_rounded
                                      : Icons.auto_graph_rounded,
                                  color: forecast.isOverBudgetRisk ? AppColors.error : AppColors.primaryLight,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  forecast.isOverBudgetRisk
                                      ? 'Cảnh báo: Nguy cơ vượt ngân sách!'
                                      : 'Dự báo chi tiêu cuối tháng',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: forecast.isOverBudgetRisk ? AppColors.error : AppColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              forecast.isOverBudgetRisk
                                  ? 'Với tốc độ chi tiêu trung bình ${CurrencyFormatter.format(forecast.dailyAverage)}/ngày, dự kiến cuối tháng bạn sẽ chi ${CurrencyFormatter.format(forecast.projectedMonthEndExpense)} (Vượt ngân sách ${CurrencyFormatter.format(forecast.projectedVariance)}).'
                                  : 'Tốc độ chi tiêu hiện tại: ${CurrencyFormatter.format(forecast.dailyAverage)}/ngày. Dự kiến cuối tháng bạn sẽ chi ${CurrencyFormatter.format(forecast.projectedMonthEndExpense)}, hoàn toàn nằm trong hạn mức an toàn.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Category Items Breakdown Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chi tiết theo danh mục',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkTextPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            SetBudgetSheet.show(
                              context,
                              month: monthState.month,
                              year: monthState.year,
                              existingBudget: budget,
                            );
                          },
                          child: const Text('Chỉnh sửa'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    if (budget.items.isEmpty)
                      const AppCard(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Center(
                          child: Text(
                            'Chưa thiết lập hạn mức riêng cho danh mục nào.',
                            style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 13),
                          ),
                        ),
                      )
                    else
                      ...budget.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: BudgetProgress(
                            categoryName: item.categoryName ?? 'Danh mục',
                            spent: item.spentAmount,
                            budgetAmount: item.limitAmount,
                            icon: IconHelper.getIcon(item.categoryIcon),
                            categoryColor: IconHelper.getColor(item.categoryColor),
                          ),
                        );
                      }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String title, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: AppColors.darkTextSecondary),
        ),
        const SizedBox(height: 2),
        AmountText(
          amount: amount,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ],
    );
  }
}
