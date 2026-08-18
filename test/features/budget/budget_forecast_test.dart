import 'package:finly/features/budget/domain/usecases/calculate_budget_forecast_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalculateBudgetForecastUseCase forecastUseCase;

  setUp(() {
    forecastUseCase = const CalculateBudgetForecastUseCase();
  });

  group('CalculateBudgetForecastUseCase Tests', () {
    test(
      'Calculates daily average and projected expense accurately on Day 10 of a 30-day month',
      () {
        // Month with 30 days (e.g. April 2026)
        // Total limit: 15,000,000
        // Spent so far: 4,000,000 on Day 10
        // Daily avg = 4,000,000 / 10 = 400,000 / day
        // Projected = 400,000 * 30 = 12,000,000
        // Risk = false (12M <= 15M)
        final testDate = DateTime(2026, 4, 10);
        final forecast = forecastUseCase(
          totalLimit: 15000000.0,
          spentSoFar: 4000000.0,
          month: 4,
          year: 2026,
          currentDate: testDate,
        );

        expect(forecast.daysPassed, equals(10));
        expect(forecast.daysInMonth, equals(30));
        expect(forecast.dailyAverage, equals(400000.0));
        expect(forecast.projectedMonthEndExpense, equals(12000000.0));
        expect(forecast.isOverBudgetRisk, isFalse);
        expect(forecast.projectedVariance, equals(-3000000.0));
      },
    );

    test('Flags over-budget risk when spending rate exceeds monthly limit', () {
      // Month with 31 days (e.g. August 2026)
      // Total limit: 10,000,000
      // Spent so far: 6,000,000 on Day 12
      // Daily avg = 6,000,000 / 12 = 500,000 / day
      // Projected = 500,000 * 31 = 15,500,000
      // Risk = true (15.5M > 10M), Variance = +5,500,000
      final testDate = DateTime(2026, 8, 12);
      final forecast = forecastUseCase(
        totalLimit: 10000000.0,
        spentSoFar: 6000000.0,
        month: 8,
        year: 2026,
        currentDate: testDate,
      );

      expect(forecast.daysPassed, equals(12));
      expect(forecast.daysInMonth, equals(31));
      expect(forecast.dailyAverage, equals(500000.0));
      expect(forecast.projectedMonthEndExpense, equals(15500000.0));
      expect(forecast.isOverBudgetRisk, isTrue);
      expect(forecast.projectedVariance, equals(5500000.0));
    });
  });
}
