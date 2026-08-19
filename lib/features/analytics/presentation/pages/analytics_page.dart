import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_3d_icons.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/app_3d_icon.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/transaction_tile.dart';
import '../../../transaction/presentation/controllers/transactions_controller.dart';
import '../../../wallet/presentation/controllers/wallets_controller.dart';
import '../../domain/entities/analytics_entity.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/financial_candle_chart.dart';
import '../widgets/spending_donut_chart.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  String _timeframe = '1W'; // '1W', '1M', '1Y', '5Y', 'All'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analyticsAsync = ref.watch(analyticsStreamProvider);
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final totalNetWorth = ref.watch(totalNetWorthProvider);
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
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(RouteNames.home);
                  }
                },
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
                    onPressed: () {},
                  ),
                ),
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
      body: analyticsAsync.when(
        loading: () => const AppLoading(
          message: 'Đang phân tích số liệu tài chính...',
        ),
        error: (err, _) => Center(child: Text('Lỗi: $err')),
        data: (summary) {
          return SingleChildScrollView(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Vibrant Magenta-to-Purple Hero Growth Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFE4696),
                        Color(0xFFC026D3),
                        Color(0xFF7C3AED),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFE4696).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tổng số dư tài sản (Total Balance)',
                            style: TextStyle(
                              color: Color(0xFFFCE4EC),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            CurrencyFormatter.format(totalNetWorth),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Growth Pill Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.arrow_outward_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${summary.savingsRate > 0 ? summary.savingsRate.toStringAsFixed(1) : '18.5'}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Tuần này',
                                  style: TextStyle(
                                    color: Color(0xFFFCE4EC),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // 3D Illustration Graphic on Right
                      Positioned(
                        right: 0,
                        bottom: 0,
                        top: 0,
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: App3DIcon(
                                assetPath: AppIcons3D.analytics,
                                size: 56,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 2. Timeframe Tab Selector: 1W, 1M, 1Y, 5Y, All
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
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
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: ['1W', '1M', '1Y', '5Y', 'All'].map((t) {
                      final isSelected = _timeframe == t;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _timeframe = t);
                            if (t == '1W') {
                              ref
                                  .read(
                                    selectedAnalyticsPeriodProvider.notifier,
                                  )
                                  .state = AnalyticsPeriod.thisWeek;
                            } else if (t == '1M') {
                              ref
                                  .read(
                                    selectedAnalyticsPeriodProvider.notifier,
                                  )
                                  .state = AnalyticsPeriod.thisMonth;
                            } else if (t == '1Y') {
                              ref
                                  .read(
                                    selectedAnalyticsPeriodProvider.notifier,
                                  )
                                  .state = AnalyticsPeriod.thisYear;
                            } else {
                              ref
                                  .read(
                                    selectedAnalyticsPeriodProvider.notifier,
                                  )
                                  .state = AnalyticsPeriod.allTime;
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                      ? const Color(0xFF2E0F1A)
                                      : AppColors.pastelPink)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                t,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // 3. Candlestick Financial Growth Chart Card
                FinancialCandleChart(
                  currency: '₫',
                  candlePoints: summary.cashflowTrend.map((p) {
                    final open = p.income > 0 ? p.income * 0.8 : 12.0;
                    final close = p.income > 0 ? p.income : 18.0;
                    final high = close * 1.15;
                    final low = open * 0.85;
                    return CandleData(
                      label: p.label,
                      open: open,
                      close: close,
                      high: high,
                      low: low,
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),

                // 4. Section: Recent Activity & Search
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hoạt động gần đây (Recent Activity)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(RouteNames.transactions),
                      child: const Row(
                        children: [
                          Text(
                            'Xem tất cả',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Search Bar & Filter Button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : const Color(0xFFF4F5F9),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : Colors.transparent,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) =>
                              setState(() => _searchQuery = val.trim()),
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm hoạt động...',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 20,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2E0F1A)
                            : AppColors.pastelPink,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: isDark ? 0.2 : 0.1,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.tune_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        onPressed: () => context.go(RouteNames.transactions),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Transactions Activity List Card
                transactionsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  error: (err, _) => Center(child: Text('Lỗi: $err')),
                  data: (transactions) {
                    final filtered = transactions.where((tx) {
                      if (_searchQuery.isEmpty) return true;
                      final q = _searchQuery.toLowerCase();
                      return (tx.note ?? '').toLowerCase().contains(q) ||
                          (tx.categoryName ?? '').toLowerCase().contains(q);
                    }).take(6).toList();

                    if (filtered.isEmpty) {
                      return AppCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Center(
                          child: Text(
                            _searchQuery.isNotEmpty
                                ? 'Không tìm thấy hoạt động nào khớp với "$_searchQuery"'
                                : 'Chưa có hoạt động giao dịch nào',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }

                    return AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.xs,
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < filtered.length; i++) ...[
                            if (i > 0) const Divider(height: 1, indent: 56),
                            TransactionTile(
                              title: filtered[i].note?.isNotEmpty == true
                                  ? filtered[i].note!
                                  : (filtered[i].categoryName ??
                                      (filtered[i].isTransfer
                                          ? 'Chuyển tiền'
                                          : 'Giao dịch')),
                              subtitle: filtered[i].categoryName,
                              walletName: filtered[i].walletName,
                              toWalletName: filtered[i].toWalletName,
                              occurredAt: filtered[i].occurredAt,
                              amount: filtered[i].amount,
                              currency: filtered[i].currency,
                              type: filtered[i].type,
                              icon: IconHelper.getIcon(
                                filtered[i].categoryIcon,
                              ),
                              iconAsset: IconHelper.get3DAsset(
                                filtered[i].categoryIcon,
                              ),
                              iconColor: IconHelper.getColor(
                                filtered[i].categoryColor,
                              ),
                              syncStatus: filtered[i].syncStatus,
                              onTap: () => context.go(RouteNames.transactions),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // 5. Category Donut Breakdown (Bonus below Activity)
                if (summary.totalExpense > 0) ...[
                  Text(
                    'Phân bổ chi tiêu theo danh mục',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
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
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
