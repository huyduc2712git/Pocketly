import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AppDatabase db;

  AnalyticsRepositoryImpl({required this.db});

  @override
  Stream<AnalyticsSummary> watchAnalytics(AnalyticsPeriod period) {
    final range = period.dateRange;
    final query = db.select(db.transactionsTable)
      ..where(
        (tbl) =>
            tbl.occurredAt.isBiggerOrEqualValue(range.start) &
            tbl.occurredAt.isSmallerOrEqualValue(range.end),
      );

    return query.watch().asyncMap((_) async {
      final summary = await _calculateSummary(period);
      return summary;
    });
  }

  @override
  Future<Result<AnalyticsSummary>> getAnalytics(AnalyticsPeriod period) async {
    try {
      final summary = await _calculateSummary(period);
      return Result.success(summary);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  Future<AnalyticsSummary> _calculateSummary(AnalyticsPeriod period) async {
    final range = period.dateRange;

    // Join transactions with categories
    final query =
        db.select(db.transactionsTable).join([
          leftOuterJoin(
            db.categoriesTable,
            db.categoriesTable.id.equalsExp(db.transactionsTable.categoryId),
          ),
        ])..where(
          db.transactionsTable.occurredAt.isBiggerOrEqualValue(range.start) &
              db.transactionsTable.occurredAt.isSmallerOrEqualValue(range.end),
        );

    final rows = await query.get();

    double totalIncome = 0.0;
    double totalExpense = 0.0;
    final Map<String, _CategoryAccumulator> categoryMap = {};

    for (final row in rows) {
      final tx = row.readTable(db.transactionsTable);
      final category = row.readTableOrNull(db.categoriesTable);

      if (tx.type == 'income') {
        totalIncome += tx.amount;
      } else if (tx.type == 'expense') {
        totalExpense += tx.amount;
        final catId = tx.categoryId ?? 'uncategorized';
        final catName = category?.name ?? 'Khác';
        final catIcon = category?.icon ?? 'category_rounded';
        final catColor = category?.color ?? '0xFF6366F1';

        if (!categoryMap.containsKey(catId)) {
          categoryMap[catId] = _CategoryAccumulator(
            id: catId,
            name: catName,
            icon: catIcon,
            color: catColor,
          );
        }
        categoryMap[catId]!.amount += tx.amount;
        categoryMap[catId]!.count += 1;
      }
    }

    final netSavings = totalIncome - totalExpense;
    final savingsRate = totalIncome > 0
        ? ((totalIncome - totalExpense) / totalIncome) * 100
        : 0.0;

    // Calculate Category Spending list
    final List<CategorySpending> topCategories = categoryMap.values.map((item) {
      final percentage = totalExpense > 0
          ? (item.amount / totalExpense) * 100
          : 0.0;
      return CategorySpending(
        categoryId: item.id,
        categoryName: item.name,
        categoryIcon: item.icon,
        categoryColor: item.color,
        amount: item.amount,
        percentage: percentage,
        transactionCount: item.count,
      );
    }).toList();

    topCategories.sort((a, b) => b.amount.compareTo(a.amount));

    // Calculate Cashflow trend points
    final cashflowTrend = _buildCashflowTrend(rows, period);

    return AnalyticsSummary(
      period: period,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netSavings: netSavings,
      savingsRate: savingsRate,
      topCategories: topCategories,
      cashflowTrend: cashflowTrend,
    );
  }

  List<CashflowPoint> _buildCashflowTrend(
    List<TypedResult> rows,
    AnalyticsPeriod period,
  ) {
    if (period == AnalyticsPeriod.thisYear) {
      // 12 months
      final Map<int, List<double>> months = {};
      for (int i = 1; i <= 12; i++) {
        months[i] = [0.0, 0.0]; // [income, expense]
      }
      for (final row in rows) {
        final tx = row.readTable(db.transactionsTable);
        final m = tx.occurredAt.month;
        if (tx.type == 'income') {
          months[m]![0] += tx.amount;
        } else if (tx.type == 'expense') {
          months[m]![1] += tx.amount;
        }
      }
      return months.entries
          .map(
            (e) => CashflowPoint(
              label: 'T${e.key}',
              income: e.value[0],
              expense: e.value[1],
            ),
          )
          .toList();
    } else {
      // Weekly breakdown for thisMonth or lastMonth
      final Map<int, List<double>> weeks = {
        1: [0.0, 0.0],
        2: [0.0, 0.0],
        3: [0.0, 0.0],
        4: [0.0, 0.0],
      };
      for (final row in rows) {
        final tx = row.readTable(db.transactionsTable);
        final day = tx.occurredAt.day;
        final week = (day <= 7)
            ? 1
            : (day <= 14)
            ? 2
            : (day <= 21)
            ? 3
            : 4;
        if (tx.type == 'income') {
          weeks[week]![0] += tx.amount;
        } else if (tx.type == 'expense') {
          weeks[week]![1] += tx.amount;
        }
      }
      return weeks.entries
          .map(
            (e) => CashflowPoint(
              label: 'Tuần ${e.key}',
              income: e.value[0],
              expense: e.value[1],
            ),
          )
          .toList();
    }
  }
}

class _CategoryAccumulator {
  final String id;
  final String name;
  final String icon;
  final String color;
  double amount = 0.0;
  int count = 0;

  _CategoryAccumulator({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}
