class BudgetItemEntity {
  final String id;
  final String budgetId;
  final String categoryId;
  final String? categoryName;
  final String? categoryIcon;
  final String? categoryColor;
  final double limitAmount;
  final double spentAmount;

  const BudgetItemEntity({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    this.categoryName,
    this.categoryIcon,
    this.categoryColor,
    required this.limitAmount,
    this.spentAmount = 0.0,
  });

  double get progressPercentage =>
      limitAmount > 0 ? (spentAmount / limitAmount) * 100 : 0.0;

  bool get isWarning => progressPercentage >= 80.0 && progressPercentage < 100.0;
  bool get isExceeded => progressPercentage >= 100.0;
  double get remainingAmount => limitAmount - spentAmount;

  BudgetItemEntity copyWith({
    String? id,
    String? budgetId,
    String? categoryId,
    String? categoryName,
    String? categoryIcon,
    String? categoryColor,
    double? limitAmount,
    double? spentAmount,
  }) {
    return BudgetItemEntity(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColor: categoryColor ?? this.categoryColor,
      limitAmount: limitAmount ?? this.limitAmount,
      spentAmount: spentAmount ?? this.spentAmount,
    );
  }
}

class BudgetForecast {
  final double dailyAverage;
  final double projectedMonthEndExpense;
  final bool isOverBudgetRisk;
  final double projectedVariance; // positive if over budget, negative if within budget
  final int daysPassed;
  final int daysInMonth;

  const BudgetForecast({
    required this.dailyAverage,
    required this.projectedMonthEndExpense,
    required this.isOverBudgetRisk,
    required this.projectedVariance,
    required this.daysPassed,
    required this.daysInMonth,
  });
}

class BudgetEntity {
  final String id;
  final String? userId;
  final int month;
  final int year;
  final double totalLimit;
  final double spentAmount;
  final String currency;
  final List<BudgetItemEntity> items;
  final BudgetForecast? forecast;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BudgetEntity({
    required this.id,
    this.userId,
    required this.month,
    required this.year,
    required this.totalLimit,
    this.spentAmount = 0.0,
    this.currency = 'VND',
    this.items = const [],
    this.forecast,
    required this.createdAt,
    required this.updatedAt,
  });

  double get remainingBudget => totalLimit - spentAmount;
  double get progressPercentage =>
      totalLimit > 0 ? (spentAmount / totalLimit) * 100 : 0.0;
  bool get isWarning => progressPercentage >= 80.0 && progressPercentage < 100.0;
  bool get isExceeded => progressPercentage >= 100.0;

  BudgetEntity copyWith({
    String? id,
    String? userId,
    int? month,
    int? year,
    double? totalLimit,
    double? spentAmount,
    String? currency,
    List<BudgetItemEntity>? items,
    BudgetForecast? forecast,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      month: month ?? this.month,
      year: year ?? this.year,
      totalLimit: totalLimit ?? this.totalLimit,
      spentAmount: spentAmount ?? this.spentAmount,
      currency: currency ?? this.currency,
      items: items ?? this.items,
      forecast: forecast ?? this.forecast,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
