import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BudgetRepositoryImpl(db: db);
});

class BudgetMonthState {
  final int month;
  final int year;

  const BudgetMonthState({required this.month, required this.year});

  BudgetMonthState next() {
    if (month == 12) {
      return BudgetMonthState(month: 1, year: year + 1);
    }
    return BudgetMonthState(month: month + 1, year: year);
  }

  BudgetMonthState prev() {
    if (month == 1) {
      return BudgetMonthState(month: 12, year: year - 1);
    }
    return BudgetMonthState(month: month - 1, year: year);
  }
}

final selectedBudgetMonthProvider = StateProvider<BudgetMonthState>((ref) {
  final now = DateTime.now();
  return BudgetMonthState(month: now.month, year: now.year);
});

final currentBudgetStreamProvider = StreamProvider<BudgetEntity?>((ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  final monthState = ref.watch(selectedBudgetMonthProvider);
  return repository.watchBudgetForMonth(monthState.month, monthState.year);
});

class BudgetController extends StateNotifier<AsyncValue<void>> {
  final BudgetRepository _repository;

  BudgetController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> setBudget({
    required int month,
    required int year,
    required double totalLimit,
    required List<BudgetItemEntity> items,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.setMonthlyBudget(
      month: month,
      year: year,
      totalLimit: totalLimit,
      items: items,
    );
    return result.when(
      success: (_) {
        state = const AsyncValue.data(null);
        return true;
      },
      failure: (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
    );
  }
}

final budgetControllerProvider =
    StateNotifierProvider<BudgetController, AsyncValue<void>>((ref) {
  final repository = ref.watch(budgetRepositoryProvider);
  return BudgetController(repository);
});
