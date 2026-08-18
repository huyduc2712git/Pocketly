import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:finly/app/router/route_names.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_icons.dart';
import 'package:finly/app/theme/app_spacing.dart';
import 'package:finly/features/insight/presentation/controllers/insights_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/balance_card.dart';
import '../widgets/budget_overview_card.dart';
import '../widgets/insight_banner_card.dart';
import '../widgets/quick_metrics_row.dart';
import '../widgets/recent_transactions_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    final topInsight = ref.watch(topInsightProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            // Glowing App Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pocketly',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Quản lý tài chính thông minh',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Notification Bell with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () => context.go(RouteNames.analytics),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.expense,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.huge + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Luxury Holographic Balance Card
            BalanceCard(
              summary: summary,
              onToggleVisibility: () {
                final current = ref.read(isBalanceVisibleProvider);
                ref.read(isBalanceVisibleProvider.notifier).state = !current;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Quick Actions 4-Pill Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickActionItem(
                  icon: AppIcons.wallet,
                  label: 'Ví tiền',
                  color: const Color(0xFF6366F1),
                  onTap: () => context.go(RouteNames.wallets),
                ),
                _buildQuickActionItem(
                  icon: AppIcons.transfer,
                  label: 'Chuyển tiền',
                  color: const Color(0xFF8B5CF6),
                  onTap: () => context.go(RouteNames.transactions),
                ),
                _buildQuickActionItem(
                  icon: AppIcons.budget,
                  label: 'Ngân sách',
                  color: const Color(0xFF06B6D4),
                  onTap: () => context.go(RouteNames.budget),
                ),
                _buildQuickActionItem(
                  icon: AppIcons.analytics,
                  label: 'Báo cáo',
                  color: const Color(0xFF10B981),
                  onTap: () => context.go(RouteNames.analytics),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Quick Metrics (Remaining budget & progress)
            QuickMetricsRow(summary: summary),
            const SizedBox(height: AppSpacing.md),

            // Smart Rule-based Insight Banner (Powered by InsightEngine)
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

            // Recent Transactions List
            RecentTransactionsCard(summary: summary),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
