import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/usecases/calculate_budget_forecast_usecase.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final AppDatabase db;
  final CalculateBudgetForecastUseCase forecastUseCase;

  BudgetRepositoryImpl({
    required this.db,
    this.forecastUseCase = const CalculateBudgetForecastUseCase(),
  });

  @override
  Stream<BudgetEntity?> watchBudgetForMonth(int month, int year) {
    return (db.select(db.budgetsTable)
          ..where((tbl) => tbl.month.equals(month) & tbl.year.equals(year)))
        .watchSingleOrNull()
        .asyncMap((budgetRow) async {
      if (budgetRow == null) return null;
      return _buildFullBudgetEntity(budgetRow);
    });
  }

  @override
  Future<Result<BudgetEntity?>> getBudgetForMonth(int month, int year) async {
    try {
      final budgetRow = await (db.select(db.budgetsTable)
            ..where((tbl) => tbl.month.equals(month) & tbl.year.equals(year)))
          .getSingleOrNull();
      if (budgetRow == null) {
        return const Result.success(null);
      }
      final budget = await _buildFullBudgetEntity(budgetRow);
      return Result.success(budget);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<BudgetEntity>> setMonthlyBudget({
    required int month,
    required int year,
    required double totalLimit,
    required List<BudgetItemEntity> items,
  }) async {
    try {
      final now = DateTime.now();
      String budgetId = '';

      await db.transaction(() async {
        final existing = await (db.select(db.budgetsTable)
              ..where((tbl) => tbl.month.equals(month) & tbl.year.equals(year)))
            .getSingleOrNull();

        if (existing != null) {
          budgetId = existing.id;
          await (db.update(db.budgetsTable)..where((tbl) => tbl.id.equals(budgetId))).write(
            BudgetsTableCompanion(
              totalAmount: Value(totalLimit),
              updatedAt: Value(now),
            ),
          );
          // Delete old budget items
          await (db.delete(db.budgetItemsTable)..where((tbl) => tbl.budgetId.equals(budgetId))).go();
        } else {
          budgetId = IdGenerator.generate();
          await db.into(db.budgetsTable).insert(
                BudgetsTableCompanion.insert(
                  id: budgetId,
                  name: 'Ngân sách $month/$year',
                  month: month,
                  year: year,
                  totalAmount: totalLimit,
                  currency: const Value('VND'),
                  createdAt: Value(now),
                  updatedAt: Value(now),
                ),
              );
        }

        // Insert new items
        for (final item in items) {
          await db.into(db.budgetItemsTable).insert(
                BudgetItemsTableCompanion.insert(
                  id: IdGenerator.generate(),
                  budgetId: budgetId,
                  categoryId: item.categoryId,
                  amount: item.limitAmount,
                  createdAt: Value(now),
                  updatedAt: Value(now),
                ),
              );
        }

        // Queue for sync
        await db.into(db.syncQueueTable).insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'budget',
                entityId: budgetId,
                operation: 'create_or_update',
                payload: '{"id": "$budgetId", "totalAmount": $totalLimit, "month": $month, "year": $year}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });

      final fullBudgetResult = await getBudgetForMonth(month, year);
      return Result.success(fullBudgetResult.dataOrNull!);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> deleteBudget(String id) async {
    try {
      await db.transaction(() async {
        await (db.delete(db.budgetItemsTable)..where((tbl) => tbl.budgetId.equals(id))).go();
        await (db.delete(db.budgetsTable)..where((tbl) => tbl.id.equals(id))).go();
      });
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  Future<BudgetEntity> _buildFullBudgetEntity(BudgetRow budgetRow) async {
    final startOfMonth = DateTime(budgetRow.year, budgetRow.month, 1);
    final endOfMonth = DateTime(budgetRow.year, budgetRow.month + 1, 0, 23, 59, 59, 999);

    // Calculate total spent in month across all expenses (excluding transfers!)
    final expenseTransactions = await (db.select(db.transactionsTable)
          ..where((tbl) =>
              tbl.type.equals('expense') &
              tbl.occurredAt.isBiggerOrEqualValue(startOfMonth) &
              tbl.occurredAt.isSmallerOrEqualValue(endOfMonth)))
        .get();

    final totalSpent = expenseTransactions.fold<double>(0.0, (sum, tx) => sum + tx.amount);

    // Query budget items joined with categories
    final itemsQuery = db.select(db.budgetItemsTable).join([
      innerJoin(db.categoriesTable, db.categoriesTable.id.equalsExp(db.budgetItemsTable.categoryId)),
    ])..where(db.budgetItemsTable.budgetId.equals(budgetRow.id));

    final itemRows = await itemsQuery.get();
    final List<BudgetItemEntity> items = [];

    for (final row in itemRows) {
      final item = row.readTable(db.budgetItemsTable);
      final category = row.readTable(db.categoriesTable);

      final categorySpent = expenseTransactions
          .where((tx) => tx.categoryId == item.categoryId)
          .fold<double>(0.0, (sum, tx) => sum + tx.amount);

      items.add(
        BudgetItemEntity(
          id: item.id,
          budgetId: item.budgetId,
          categoryId: item.categoryId,
          categoryName: category.name,
          categoryIcon: category.icon,
          categoryColor: category.color,
          limitAmount: item.amount,
          spentAmount: categorySpent,
        ),
      );
    }

    final forecast = forecastUseCase(
      totalLimit: budgetRow.totalAmount,
      spentSoFar: totalSpent,
      month: budgetRow.month,
      year: budgetRow.year,
    );

    return BudgetEntity(
      id: budgetRow.id,
      userId: budgetRow.userId,
      month: budgetRow.month,
      year: budgetRow.year,
      totalLimit: budgetRow.totalAmount,
      spentAmount: totalSpent,
      currency: budgetRow.currency,
      items: items,
      forecast: forecast,
      createdAt: budgetRow.createdAt,
      updatedAt: budgetRow.updatedAt,
    );
  }
}
