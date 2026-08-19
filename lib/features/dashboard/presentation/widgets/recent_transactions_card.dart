import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finly/app/router/route_names.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_spacing.dart';
import 'package:finly/core/extensions/context_extensions.dart';
import 'package:finly/core/utils/icon_helper.dart';
import 'package:finly/shared/widgets/app_card.dart';
import 'package:finly/shared/widgets/transaction_tile.dart';
import '../controllers/dashboard_controller.dart';

class RecentTransactionsCard extends StatefulWidget {
  final DashboardSummary summary;

  const RecentTransactionsCard({super.key, required this.summary});

  @override
  State<RecentTransactionsCard> createState() => _RecentTransactionsCardState();
}

class _RecentTransactionsCardState extends State<RecentTransactionsCard> {
  String _selectedFilter = 'all'; // 'all', 'income', 'expense'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final filteredList = widget.summary.recentTransactions.where((tx) {
      if (_selectedFilter == 'income' && !tx.isIncome) return false;
      if (_selectedFilter == 'expense' && !tx.isExpense) return false;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final note = (tx.note ?? '').toLowerCase();
        final cat = (tx.categoryName ?? '').toLowerCase();
        final wallet = (tx.walletName ?? '').toLowerCase();
        return note.contains(query) || cat.contains(query) || wallet.contains(query);
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row: "Recent Transaction" & "See all"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Giao dịch gần đây',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => context.go(RouteNames.transactions),
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
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
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF4F5F9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : Colors.transparent,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm giao dịch...',
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
                            icon: const Icon(Icons.clear_rounded, size: 16),
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
                color: isDark ? AppColors.darkSurface : const Color(0xFFF4F5F9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : Colors.transparent,
                ),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                onPressed: () => context.go(RouteNames.transactions),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Filter Pills: All, Income, Expense
        Row(
          children: [
            _buildFilterPill(
              label: 'Tất cả',
              value: 'all',
              isSelected: _selectedFilter == 'all',
              indicatorColor: null,
            ),
            const SizedBox(width: AppSpacing.xs),
            _buildFilterPill(
              label: 'Thu nhập',
              value: 'income',
              isSelected: _selectedFilter == 'income',
              indicatorColor: AppColors.income,
            ),
            const SizedBox(width: AppSpacing.xs),
            _buildFilterPill(
              label: 'Chi tiêu',
              value: 'expense',
              isSelected: _selectedFilter == 'expense',
              indicatorColor: AppColors.expense,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Transactions List
        if (filteredList.isEmpty)
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'Không tìm thấy giao dịch nào khớp với "$_searchQuery"'
                    : 'Chưa có giao dịch gần đây',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xs,
            ),
            child: Column(
              children: [
                for (int i = 0; i < filteredList.length; i++) ...[
                  if (i > 0) const Divider(height: 1, indent: 56),
                  TransactionTile(
                    title: filteredList[i].note?.isNotEmpty == true
                        ? filteredList[i].note!
                        : (filteredList[i].categoryName ??
                            (filteredList[i].isTransfer
                                ? 'Chuyển tiền'
                                : 'Giao dịch')),
                    subtitle: filteredList[i].categoryName,
                    walletName: filteredList[i].walletName,
                    toWalletName: filteredList[i].toWalletName,
                    occurredAt: filteredList[i].occurredAt,
                    amount: filteredList[i].amount,
                    currency: filteredList[i].currency,
                    type: filteredList[i].type,
                    icon: IconHelper.getIcon(filteredList[i].categoryIcon),
                    iconAsset: IconHelper.get3DAsset(filteredList[i].categoryIcon),
                    iconColor: IconHelper.getColor(filteredList[i].categoryColor),
                    syncStatus: filteredList[i].syncStatus,
                    onTap: () => context.go(RouteNames.transactions),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFilterPill({
    required String label,
    required String value,
    required bool isSelected,
    required Color? indicatorColor,
  }) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedFilter = value),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark
                    ? AppColors.darkSurface
                    : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : const Color(0xFFE5E7EB)),
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (indicatorColor != null && !isSelected) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
