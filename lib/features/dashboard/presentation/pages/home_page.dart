import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading.dart';
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
    final dashboardState = ref.watch(dashboardControllerProvider);

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
            onPressed: () {
              // Notification center placeholder
            },
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: dashboardState.when(
        loading: () => const AppLoading(message: 'Đang tải dữ liệu tài chính...'),
        error: (err, _) => AppErrorState(
          title: 'Không thể tải dữ liệu',
          message: err.toString(),
          onRetry: () => ref.read(dashboardControllerProvider.notifier).loadDashboardData(),
        ),
        data: (summary) {
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(dashboardControllerProvider.notifier).loadDashboardData(),
            child: SingleChildScrollView(
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
                    onToggleVisibility: () => ref
                        .read(dashboardControllerProvider.notifier)
                        .toggleBalanceVisibility(),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Quick Metrics (Remaining budget & progress)
                  QuickMetricsRow(summary: summary),
                  const SizedBox(height: AppSpacing.md),

                  // Smart Rule-based Insight Banner
                  InsightBannerCard(
                    title: 'Chi tiêu ăn uống tăng 20%',
                    message:
                        'Bạn đã chi tiêu 3.2M ₫ cho Ăn uống trong tuần này, cao hơn 20% so với tuần trước.',
                    onTap: () => context.go('/analytics'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Category Budgets Overview
                  BudgetOverviewCard(
                    onManageBudget: () => context.go('/budget'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Recent Transactions List
                  RecentTransactionsCard(
                    onViewAll: () => context.go('/transactions'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
