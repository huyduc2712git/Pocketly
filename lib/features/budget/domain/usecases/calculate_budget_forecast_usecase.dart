import '../entities/budget_entity.dart';

class CalculateBudgetForecastUseCase {
  const CalculateBudgetForecastUseCase();

  BudgetForecast call({
    required double totalLimit,
    required double spentSoFar,
    required int month,
    required int year,
    DateTime? currentDate,
  }) {
    final now = currentDate ?? DateTime.now();
    // Days in specified month
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Calculate days passed in month
    int daysPassed;
    if (now.year == year && now.month == month) {
      daysPassed = now.day > 0 ? now.day : 1;
    } else if (DateTime(year, month).isBefore(DateTime(now.year, now.month))) {
      // Past month
      daysPassed = daysInMonth;
    } else {
      // Future month
      daysPassed = 1;
    }

    final dailyAverage = spentSoFar > 0 ? spentSoFar / daysPassed : 0.0;
    final projectedExpense = dailyAverage * daysInMonth;
    final isOverBudgetRisk = totalLimit > 0 && projectedExpense > totalLimit;
    final projectedVariance = projectedExpense - totalLimit;

    return BudgetForecast(
      dailyAverage: dailyAverage,
      projectedMonthEndExpense: projectedExpense,
      isOverBudgetRisk: isOverBudgetRisk,
      projectedVariance: projectedVariance,
      daysPassed: daysPassed,
      daysInMonth: daysInMonth,
    );
  }
}
