import '../../../../core/result/result.dart';
import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  Stream<BudgetEntity?> watchBudgetForMonth(int month, int year);
  Future<Result<BudgetEntity?>> getBudgetForMonth(int month, int year);
  Future<Result<BudgetEntity>> setMonthlyBudget({
    required int month,
    required int year,
    required double totalLimit,
    required List<BudgetItemEntity> items,
  });
  Future<Result<void>> deleteBudget(String id);
}
