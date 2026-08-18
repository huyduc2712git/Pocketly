import 'package:finly/features/analytics/domain/entities/analytics_entity.dart';
import 'package:finly/features/budget/domain/entities/budget_entity.dart';
import 'package:finly/features/insight/domain/entities/insight_entity.dart';
import 'package:finly/features/insight/domain/services/insight_engine_service.dart';
import 'package:finly/features/subscription/domain/entities/subscription_entity.dart';
import 'package:finly/features/wallet/domain/entities/wallet_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InsightEngineService service;

  setUp(() {
    service = const InsightEngineService();
  });

  group('InsightEngineService 5-Rule Tests', () {
    test('Rule 1: Detects category spending spike (> 20% increase)', () {
      const lastMonth = AnalyticsSummary(
        period: AnalyticsPeriod.lastMonth,
        totalIncome: 20000000.0,
        totalExpense: 10000000.0,
        netSavings: 10000000.0,
        savingsRate: 50.0,
        topCategories: [
          CategorySpending(
            categoryId: 'cat_food',
            categoryName: 'Ăn uống',
            categoryIcon: 'food',
            categoryColor: '0xFF10B981',
            amount: 2000000.0,
            percentage: 20.0,
            transactionCount: 10,
          ),
        ],
        cashflowTrend: [],
      );

      // This month Food increased to 3,000,000 (+50% increase)
      const thisMonth = AnalyticsSummary(
        period: AnalyticsPeriod.thisMonth,
        totalIncome: 20000000.0,
        totalExpense: 12000000.0,
        netSavings: 8000000.0,
        savingsRate: 40.0,
        topCategories: [
          CategorySpending(
            categoryId: 'cat_food',
            categoryName: 'Ăn uống',
            categoryIcon: 'food',
            categoryColor: '0xFF10B981',
            amount: 3000000.0,
            percentage: 25.0,
            transactionCount: 15,
          ),
        ],
        cashflowTrend: [],
      );

      final insights = service.evaluateAllRules(
        thisMonthAnalytics: thisMonth,
        lastMonthAnalytics: lastMonth,
      );

      expect(insights.any((i) => i.type == 'category_spike'), isTrue);
      final spike = insights.firstWhere((i) => i.type == 'category_spike');
      expect(spike.severity, equals(InsightSeverity.warning));
    });

    test('Rule 2: Detects budget risk when forecast exceeds limit', () {
      final budget = BudgetEntity(
        id: 'b1',
        month: 8,
        year: 2026,
        totalLimit: 10000000.0,
        spentAmount: 8000000.0,
        forecast: const BudgetForecast(
          dailyAverage: 500000.0,
          projectedMonthEndExpense: 15500000.0,
          isOverBudgetRisk: true,
          projectedVariance: 5500000.0,
          daysPassed: 16,
          daysInMonth: 31,
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final insights = service.evaluateAllRules(currentBudget: budget);
      expect(insights.any((i) => i.type == 'budget_risk'), isTrue);
      final risk = insights.firstWhere((i) => i.type == 'budget_risk');
      expect(risk.severity, equals(InsightSeverity.critical));
    });

    test('Rule 3: Detects upcoming subscription renewal within 2 days', () {
      final now = DateTime.now();
      final sub = SubscriptionEntity(
        id: 'sub1',
        name: 'Spotify Family',
        amount: 89000.0,
        walletId: 'w1',
        nextBillingDate: now.add(const Duration(days: 1)),
        remindDaysBefore: 2,
        createdAt: now,
        updatedAt: now,
      );

      final insights = service.evaluateAllRules(subscriptions: [sub]);
      expect(insights.any((i) => i.type == 'upcoming_subscription'), isTrue);
    });

    test('Rule 4: Celebrates savings rate discipline when >= 30%', () {
      const thisMonth = AnalyticsSummary(
        period: AnalyticsPeriod.thisMonth,
        totalIncome: 30000000.0,
        totalExpense: 15000000.0,
        netSavings: 15000000.0,
        savingsRate: 50.0, // 50% >= 30%
        topCategories: [],
        cashflowTrend: [],
      );

      final insights = service.evaluateAllRules(thisMonthAnalytics: thisMonth);
      expect(insights.any((i) => i.type == 'savings_achievement'), isTrue);
      final achievement = insights.firstWhere((i) => i.type == 'savings_achievement');
      expect(achievement.severity, equals(InsightSeverity.positive));
    });

    test('Rule 5: Detects low wallet balance (< 100k)', () {
      final now = DateTime.now();
      final wallet = WalletEntity(
        id: 'w_low',
        name: 'Ví tiền mặt',
        type: WalletType.cash,
        balance: 45000.0, // < 100,000
        createdAt: now,
        updatedAt: now,
      );

      final insights = service.evaluateAllRules(wallets: [wallet]);
      expect(insights.any((i) => i.type == 'low_balance'), isTrue);
    });
  });
}
