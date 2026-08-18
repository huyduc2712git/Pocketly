import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardSummary {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final double totalBudget;
  final double budgetSpent;
  final String currency;
  final bool isBalanceHidden;

  const DashboardSummary({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.totalBudget,
    required this.budgetSpent,
    this.currency = 'VND',
    this.isBalanceHidden = false,
  });

  double get remainingBudget => totalBudget - budgetSpent;
  double get budgetProgressPercentage =>
      totalBudget > 0 ? (budgetSpent / totalBudget) * 100 : 0.0;

  DashboardSummary copyWith({
    double? totalBalance,
    double? monthlyIncome,
    double? monthlyExpense,
    double? totalBudget,
    double? budgetSpent,
    String? currency,
    bool? isBalanceHidden,
  }) {
    return DashboardSummary(
      totalBalance: totalBalance ?? this.totalBalance,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlyExpense: monthlyExpense ?? this.monthlyExpense,
      totalBudget: totalBudget ?? this.totalBudget,
      budgetSpent: budgetSpent ?? this.budgetSpent,
      currency: currency ?? this.currency,
      isBalanceHidden: isBalanceHidden ?? this.isBalanceHidden,
    );
  }
}

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardSummary>> {
  DashboardNotifier() : super(const AsyncValue.loading()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    state = const AsyncValue.loading();
    try {
      // Phase 1 Mock/Seed Data
      await Future.delayed(const Duration(milliseconds: 200));
      state = const AsyncValue.data(
        DashboardSummary(
          totalBalance: 18300000.0,
          monthlyIncome: 25000000.0,
          monthlyExpense: 6700000.0,
          totalBudget: 12000000.0,
          budgetSpent: 6700000.0,
          currency: 'VND',
          isBalanceHidden: false,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void toggleBalanceVisibility() {
    state.whenData((data) {
      state = AsyncValue.data(
        data.copyWith(isBalanceHidden: !data.isBalanceHidden),
      );
    });
  }
}

final dashboardControllerProvider =
    StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardSummary>>((ref) {
  return DashboardNotifier();
});
