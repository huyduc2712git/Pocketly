import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../budget/presentation/controllers/budget_controller.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../transaction/domain/entities/transaction_filter.dart';
import '../../../transaction/presentation/controllers/transactions_controller.dart';
import '../../../wallet/presentation/controllers/wallets_controller.dart';

class DashboardSummary {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final double remainingBudget;
  final double totalBudgetLimit;
  final double budgetProgressPercentage;
  final String currency;
  final bool isBalanceHidden;
  final List<TransactionEntity> recentTransactions;
  final String? topSpendingCategoryName;
  final double? topSpendingCategoryAmount;

  const DashboardSummary({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.remainingBudget,
    required this.totalBudgetLimit,
    required this.budgetProgressPercentage,
    this.currency = 'VND',
    this.isBalanceHidden = false,
    required this.recentTransactions,
    this.topSpendingCategoryName,
    this.topSpendingCategoryAmount,
  });
}

final isBalanceVisibleProvider = StateProvider<bool>((ref) => true);

// Recent 5 transactions for dashboard
final recentTransactionsProvider = StreamProvider<List<TransactionEntity>>((
  ref,
) {
  final useCase = ref.watch(getTransactionsUseCaseProvider);
  return useCase.watch(filter: const TransactionFilter());
});

// Current month transactions for quick dashboard calculations
final currentMonthTransactionsProvider =
    StreamProvider<List<TransactionEntity>>((ref) {
      final useCase = ref.watch(getTransactionsUseCaseProvider);
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
      return useCase.watch(
        filter: TransactionFilter(startDate: startOfMonth, endDate: endOfMonth),
      );
    });

final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final totalBalance = ref.watch(totalNetWorthProvider);
  final txAsync = ref.watch(currentMonthTransactionsProvider);
  final allRecentTxAsync = ref.watch(recentTransactionsProvider);
  final budgetAsync = ref.watch(currentBudgetStreamProvider);
  final isVisible = ref.watch(isBalanceVisibleProvider);

  final monthTransactions = txAsync.valueOrNull ?? [];
  final allRecentTransactions = allRecentTxAsync.valueOrNull ?? [];

  double monthlyIncome = 0.0;
  double monthlyExpense = 0.0;
  final Map<String, double> categoryExpenseMap = {};

  for (final tx in monthTransactions) {
    if (tx.type == 'income') {
      monthlyIncome += tx.amount;
    } else if (tx.type == 'expense') {
      monthlyExpense += tx.amount;
      final name = tx.categoryName ?? 'Khác';
      categoryExpenseMap[name] = (categoryExpenseMap[name] ?? 0.0) + tx.amount;
    }
  }

  String? topCatName;
  double? topCatAmount;
  if (categoryExpenseMap.isNotEmpty) {
    final sorted = categoryExpenseMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    topCatName = sorted.first.key;
    topCatAmount = sorted.first.value;
  }

  final budget = budgetAsync.valueOrNull;
  final totalBudgetLimit = budget?.totalLimit ?? 0.0;
  final remainingBudget = totalBudgetLimit > 0
      ? (totalBudgetLimit - monthlyExpense)
      : 0.0;
  final budgetProgressPercentage = totalBudgetLimit > 0
      ? (monthlyExpense / totalBudgetLimit) * 100
      : 0.0;

  return DashboardSummary(
    totalBalance: totalBalance,
    monthlyIncome: monthlyIncome,
    monthlyExpense: monthlyExpense,
    remainingBudget: remainingBudget,
    totalBudgetLimit: totalBudgetLimit,
    budgetProgressPercentage: budgetProgressPercentage,
    isBalanceHidden: !isVisible,
    recentTransactions: allRecentTransactions.take(5).toList(),
    topSpendingCategoryName: topCatName,
    topSpendingCategoryAmount: topCatAmount,
  );
});
