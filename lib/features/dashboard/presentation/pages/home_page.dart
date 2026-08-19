import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:finly/app/router/route_names.dart';
import 'package:finly/app/theme/app_3d_icons.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_spacing.dart';
import 'package:finly/core/extensions/context_extensions.dart';
import 'package:finly/features/insight/presentation/controllers/insights_controller.dart';
import 'package:finly/features/transaction/presentation/widgets/quick_add_transaction_sheet.dart';
import 'package:finly/shared/widgets/quick_action_fab.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/balance_card.dart';
import '../widgets/budget_overview_card.dart';
import '../widgets/insight_banner_card.dart';
import '../widgets/metric_sparkline_card.dart';
import '../widgets/recent_transactions_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    final topInsight = ref.watch(topInsightProvider);
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFF0F1F5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.notes_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => context.go(RouteNames.profile),
              ),
            ),
          ),
        ),
        title: null,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : const Color(0xFFF0F1F5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.2 : 0.03,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () => context.go(RouteNames.analytics),
                  ),
                ),
                // Red unread badge dot
                Positioned(
                  top: 3,
                  right: 3,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3B30),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.bottomClearance,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Balance Card
            BalanceCard(
              summary: summary,
              onToggleVisibility: () {
                final current = ref.read(isBalanceVisibleProvider);
                ref.read(isBalanceVisibleProvider.notifier).state = !current;
              },
              onViewDetails: () => context.push(RouteNames.wallets),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 4 Circular Quick Action Buttons (Send, Receive, Loan, Top Up)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCircularActionItem(
                  context,
                  label: 'Gửi tiền',
                  icon: Icons.arrow_outward_rounded,
                  iconColor: AppColors.primary,
                  bgColor: isDark
                      ? const Color(0xFF2E0F1A)
                      : AppColors.pastelPink,
                  onTap: () => QuickAddTransactionSheet.show(
                    context,
                    initialType: QuickActionType.transfer,
                  ),
                ),
                _buildCircularActionItem(
                  context,
                  label: 'Nhận tiền',
                  icon: Icons.south_west_rounded,
                  iconColor: AppColors.income,
                  bgColor: isDark
                      ? const Color(0xFF0D2818)
                      : AppColors.pastelMint,
                  onTap: () => QuickAddTransactionSheet.show(
                    context,
                    initialType: QuickActionType.income,
                  ),
                ),
                _buildCircularActionItem(
                  context,
                  label: 'Sổ nợ / Ví',
                  icon: Icons.attach_money_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  bgColor: isDark
                      ? const Color(0xFF2D2305)
                      : AppColors.pastelAmber,
                  onTap: () => context.push(RouteNames.wallets),
                ),
                _buildCircularActionItem(
                  context,
                  label: 'Nạp tiền',
                  icon: Icons.add_rounded,
                  iconColor: const Color(0xFF3B82F6),
                  bgColor: isDark
                      ? const Color(0xFF0C1F38)
                      : AppColors.pastelSkyBlue,
                  onTap: () => QuickAddTransactionSheet.show(
                    context,
                    initialType: QuickActionType.expense,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // 3 Summary Metric Sparkline Cards (Income, Expense, Savings)
            Row(
              children: [
                Expanded(
                  child: MetricSparklineCard(
                    title: 'Thu nhập',
                    amount: summary.monthlyIncome,
                    currency: summary.currency,
                    type: SparklineType.income,
                    iconAsset: AppIcons3D.salary,
                    onTap: () => context.go(RouteNames.analytics),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs + 2),
                Expanded(
                  child: MetricSparklineCard(
                    title: 'Chi tiêu',
                    amount: summary.monthlyExpense,
                    currency: summary.currency,
                    type: SparklineType.expense,
                    iconAsset: AppIcons3D.bills,
                    onTap: () => context.go(RouteNames.analytics),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs + 2),
                Expanded(
                  child: MetricSparklineCard(
                    title: 'Tiết kiệm',
                    amount: summary.netSavings,
                    currency: summary.currency,
                    type: SparklineType.savings,
                    iconAsset: AppIcons3D.savings,
                    onTap: () => context.go(RouteNames.analytics),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Smart Rule-based Insight Banner
            InsightBannerCard(
              title: topInsight != null
                  ? topInsight.title
                  : (summary.topSpendingCategoryName != null
                        ? 'Khoản chi lớn nhất: ${summary.topSpendingCategoryName}'
                        : 'Pocketly Smart Insight'),
              message: topInsight != null
                  ? topInsight.message
                  : (summary.topSpendingCategoryName != null
                        ? 'Bạn đã chi tiêu cho ${summary.topSpendingCategoryName} trong tháng này.'
                        : 'Ghi nhận thu chi đều đặn mỗi ngày để nhận phân tích tài chính thông minh.'),
              onTap: () => context.go(RouteNames.analytics),
            ),
            const SizedBox(height: AppSpacing.md),

            // Category Budgets Overview
            BudgetOverviewCard(
              onManageBudget: () => context.go(RouteNames.budget),
            ),
            const SizedBox(height: AppSpacing.md),

            // Recent Transactions List with Search & Filters
            RecentTransactionsCard(summary: summary),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularActionItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: bgColor.withValues(alpha: isDark ? 0.3 : 0.6),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
