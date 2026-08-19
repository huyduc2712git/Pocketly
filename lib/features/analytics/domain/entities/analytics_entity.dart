enum AnalyticsPeriod {
  thisWeek,
  thisMonth,
  lastMonth,
  last3Months,
  thisYear,
  allTime;

  String get displayName {
    switch (this) {
      case AnalyticsPeriod.thisWeek:
        return 'Tuần này';
      case AnalyticsPeriod.thisMonth:
        return 'Tháng này';
      case AnalyticsPeriod.lastMonth:
        return 'Tháng trước';
      case AnalyticsPeriod.last3Months:
        return '3 tháng gần nhất';
      case AnalyticsPeriod.thisYear:
        return 'Năm nay';
      case AnalyticsPeriod.allTime:
        return 'Tất cả thời gian';
    }
  }

  DateTimeRange get dateRange {
    final now = DateTime.now();
    switch (this) {
      case AnalyticsPeriod.thisWeek:
        final start = now.subtract(Duration(days: now.weekday - 1));
        final startOfDay = DateTime(start.year, start.month, start.day);
        final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        return DateTimeRange(start: startOfDay, end: end);
      case AnalyticsPeriod.thisMonth:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
        return DateTimeRange(start: start, end: end);
      case AnalyticsPeriod.lastMonth:
        final start = DateTime(now.year, now.month - 1, 1);
        final end = DateTime(now.year, now.month, 0, 23, 59, 59, 999);
        return DateTimeRange(start: start, end: end);
      case AnalyticsPeriod.last3Months:
        final start = DateTime(now.year, now.month - 2, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
        return DateTimeRange(start: start, end: end);
      case AnalyticsPeriod.thisYear:
        final start = DateTime(now.year, 1, 1);
        final end = DateTime(now.year, 12, 31, 23, 59, 59, 999);
        return DateTimeRange(start: start, end: end);
      case AnalyticsPeriod.allTime:
        final start = DateTime(2020, 1, 1);
        final end = DateTime(now.year + 1, 12, 31, 23, 59, 59, 999);
        return DateTimeRange(start: start, end: end);
    }
  }
}

class DateTimeRange {
  final DateTime start;
  final DateTime end;

  const DateTimeRange({required this.start, required this.end});
}

class CategorySpending {
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final double amount;
  final double percentage; // 0.0 to 100.0
  final int transactionCount;

  const CategorySpending({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.amount,
    required this.percentage,
    required this.transactionCount,
  });
}

class CashflowPoint {
  final String label; // e.g. "T1", "T2" or "Tuần 1", "Tuần 2"
  final double income;
  final double expense;

  const CashflowPoint({
    required this.label,
    required this.income,
    required this.expense,
  });
}

class AnalyticsSummary {
  final AnalyticsPeriod period;
  final double totalIncome;
  final double totalExpense;
  final double netSavings;
  final double savingsRate; // Percentage e.g. 25.5%
  final List<CategorySpending> topCategories;
  final List<CashflowPoint> cashflowTrend;

  const AnalyticsSummary({
    required this.period,
    required this.totalIncome,
    required this.totalExpense,
    required this.netSavings,
    required this.savingsRate,
    required this.topCategories,
    required this.cashflowTrend,
  });
}
