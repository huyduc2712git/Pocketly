import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/quick_action_fab.dart';
import '../../../../shared/widgets/transaction_tile.dart';
import '../../../wallet/presentation/controllers/wallets_controller.dart';
import '../../domain/entities/transaction_entity.dart';
import '../controllers/transactions_controller.dart';
import '../widgets/quick_add_transaction_sheet.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final currentFilter = ref.watch(transactionFilterProvider);
    final walletsAsync = ref.watch(walletsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ Thu Chi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Bộ lọc nâng cao',
            onPressed: () => _showFilterBottomSheet(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    label: 'Tất cả loại',
                    isSelected: currentFilter.type == null,
                    onTap: () =>
                        ref.read(transactionFilterProvider.notifier).state =
                            currentFilter.copyWith(clearType: true),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _buildFilterChip(
                    label: 'Khoản chi',
                    isSelected: currentFilter.type == 'expense',
                    onTap: () =>
                        ref.read(transactionFilterProvider.notifier).state =
                            currentFilter.copyWith(type: 'expense'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _buildFilterChip(
                    label: 'Khoản thu',
                    isSelected: currentFilter.type == 'income',
                    onTap: () =>
                        ref.read(transactionFilterProvider.notifier).state =
                            currentFilter.copyWith(type: 'income'),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _buildFilterChip(
                    label: 'Chuyển tiền',
                    isSelected: currentFilter.type == 'transfer',
                    onTap: () =>
                        ref.read(transactionFilterProvider.notifier).state =
                            currentFilter.copyWith(type: 'transfer'),
                  ),
                  if (walletsAsync.hasValue &&
                      walletsAsync.value!.isNotEmpty) ...[
                    const SizedBox(width: AppSpacing.xs),
                    ...walletsAsync.value!.map(
                      (w) => Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: _buildFilterChip(
                          label: w.name,
                          isSelected: currentFilter.walletId == w.id,
                          onTap: () {
                            final isCurrent = currentFilter.walletId == w.id;
                            ref
                                .read(transactionFilterProvider.notifier)
                                .state = currentFilter.copyWith(
                              walletId: isCurrent ? null : w.id,
                              clearWallet: isCurrent,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Transactions List grouped by Day
          Expanded(
            child: transactionsAsync.when(
              loading: () =>
                  const AppLoading(message: 'Đang tải sổ giao dịch...'),
              error: (err, _) => Center(child: Text('Lỗi: $err')),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return AppEmptyState(
                    title: 'Chưa có giao dịch nào',
                    message:
                        'Nhấn nút "+" bên dưới để tạo khoản thu chi đầu tiên của bạn.',
                    actionText: 'Thêm giao dịch ngay',
                    onActionPressed: () => QuickAddTransactionSheet.show(
                      context,
                      initialType: QuickActionType.expense,
                    ),
                  );
                }

                final grouped = _groupTransactionsByDate(transactions);

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: grouped.keys.length,
                  itemBuilder: (context, index) {
                    final dateKey = grouped.keys.elementAt(index);
                    final dayTransactions = grouped[dateKey]!;

                    final daySpent = dayTransactions
                        .where((t) => t.isExpense)
                        .fold(0.0, (sum, t) => sum + t.amount);
                    final dayIncome = dayTransactions
                        .where((t) => t.isIncome)
                        .fold(0.0, (sum, t) => sum + t.amount);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDayHeader(
                            dateKey,
                            totalSpent: daySpent > 0 ? daySpent : null,
                            totalEarned: dayIncome > 0 ? dayIncome : null,
                          ),
                          const SizedBox(height: 4),
                          AppCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: AppSpacing.xs,
                            ),
                            child: Column(
                              children: [
                                for (
                                  int i = 0;
                                  i < dayTransactions.length;
                                  i++
                                ) ...[
                                  if (i > 0)
                                    const Divider(height: 1, indent: 56),
                                  Dismissible(
                                    key: ValueKey(dayTransactions[i].id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.error,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    confirmDismiss: (dir) => _confirmDelete(
                                      context,
                                      ref,
                                      dayTransactions[i],
                                    ),
                                    child: TransactionTile(
                                      title:
                                          dayTransactions[i].note?.isNotEmpty ==
                                              true
                                          ? dayTransactions[i].note!
                                          : (dayTransactions[i].categoryName ??
                                                (dayTransactions[i].isTransfer
                                                    ? 'Chuyển tiền'
                                                    : 'Giao dịch')),
                                      subtitle: dayTransactions[i].categoryName,
                                      walletName: dayTransactions[i].walletName,
                                      toWalletName:
                                          dayTransactions[i].toWalletName,
                                      occurredAt: dayTransactions[i].occurredAt,
                                      amount: dayTransactions[i].amount,
                                      currency: dayTransactions[i].currency,
                                      type: dayTransactions[i].type,
                                      icon: IconHelper.getIcon(
                                        dayTransactions[i].categoryIcon,
                                      ),
                                      iconColor: IconHelper.getColor(
                                        dayTransactions[i].categoryColor,
                                      ),
                                      syncStatus: dayTransactions[i].syncStatus,
                                      onTap: () => _showTransactionActions(
                                        context,
                                        ref,
                                        dayTransactions[i],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<TransactionEntity>> _groupTransactionsByDate(
    List<TransactionEntity> transactions,
  ) {
    final Map<DateTime, List<TransactionEntity>> groups = {};
    for (final tx in transactions) {
      final date = DateTime(
        tx.occurredAt.year,
        tx.occurredAt.month,
        tx.occurredAt.day,
      );
      if (!groups.containsKey(date)) {
        groups[date] = [];
      }
      groups[date]!.add(tx);
    }
    return groups;
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.darkCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.darkBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.darkTextSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDayHeader(
    DateTime date, {
    double? totalSpent,
    double? totalEarned,
  }) {
    final title =
        '${date.toRelativeDate}, ${DateFormatter.formatFullDate(date)}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextSecondary,
            ),
          ),
          Row(
            children: [
              if (totalIncomeString(totalEarned).isNotEmpty) ...[
                Text(
                  '+${CurrencyFormatter.format(totalEarned!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.income,
                  ),
                ),
                if (totalSpent != null) const SizedBox(width: 8),
              ],
              if (totalSpent != null)
                Text(
                  '-${CurrencyFormatter.format(totalSpent)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.expense,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String totalIncomeString(double? total) =>
      total != null && total > 0 ? total.toString() : '';

  Future<bool> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    TransactionEntity transaction,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa giao dịch này?'),
        content: Text(
          'Số tiền ${CurrencyFormatter.format(transaction.amount)} sẽ được tự động hoàn lại vào số dư ví tương ứng.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xóa', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (result == true) {
      final success = await ref
          .read(transactionsControllerProvider.notifier)
          .deleteTransaction(transaction);
      if (success && context.mounted) {
        context.showSnackBar('Đã xóa giao dịch và cập nhật lại số dư ví.');
      }
      return success;
    }
    return false;
  }

  void _showTransactionActions(
    BuildContext context,
    WidgetRef ref,
    TransactionEntity transaction,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Chi tiết giao dịch',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
              ),
              title: const Text(
                'Xóa giao dịch',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                _confirmDelete(context, ref, transaction);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    // Advanced filter sheet placeholder
  }
}
