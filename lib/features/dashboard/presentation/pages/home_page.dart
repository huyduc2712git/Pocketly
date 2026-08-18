import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../insight/presentation/controllers/insights_controller.dart';
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
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'F',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Finly',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Quản lý tài chính thông minh',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkTextMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.huge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Balance Card
            BalanceCard(
              summary: summary,
              onToggleVisibility: () {
                final current = ref.read(isBalanceVisibleProvider);
                ref.read(isBalanceVisibleProvider.notifier).state = !current;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Quick Metrics (Remaining budget & progress)
            QuickMetricsRow(summary: summary),
            const SizedBox(height: AppSpacing.md),

            // Smart Rule-based Insight Banner (Powered by InsightEngine)
            InsightBannerCard(
              title: topInsight != null
                  ? topInsight.title
                  : (summary.topSpendingCategoryName != null
                      ? 'Khoản chi lớn nhất: ${summary.topSpendingCategoryName}'
                      : 'Tổng quan chi tiêu thông minh'),
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
}
