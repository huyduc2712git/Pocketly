import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../analytics/domain/entities/analytics_entity.dart';
import '../../../budget/domain/entities/budget_entity.dart';
import '../../../subscription/domain/entities/subscription_entity.dart';
import '../../../wallet/domain/entities/wallet_entity.dart';
import '../entities/insight_entity.dart';

class InsightEngineService {
  const InsightEngineService();

  List<InsightEntity> evaluateAllRules({
    AnalyticsSummary? thisMonthAnalytics,
    AnalyticsSummary? lastMonthAnalytics,
    BudgetEntity? currentBudget,
    List<SubscriptionEntity> subscriptions = const [],
    List<WalletEntity> wallets = const [],
  }) {
    final List<InsightEntity> insights = [];
    final now = DateTime.now();

    // --- Rule 1: Category Spike Detection (>20% increase) ---
    if (thisMonthAnalytics != null && lastMonthAnalytics != null) {
      final lastMonthMap = {
        for (var c in lastMonthAnalytics.topCategories) c.categoryId: c.amount,
      };

      for (final cat in thisMonthAnalytics.topCategories) {
        final lastAmount = lastMonthMap[cat.categoryId] ?? 0.0;
        if (lastAmount > 0 && cat.amount >= 500000.0) {
          final increaseRatio = (cat.amount - lastAmount) / lastAmount;
          if (increaseRatio >= 0.20) {
            final percent = (increaseRatio * 100).toStringAsFixed(0);
            insights.add(
              InsightEntity(
                id: IdGenerator.generate(),
                type: 'category_spike',
                title: 'Chi tiêu ${cat.categoryName} tăng $percent%',
                message:
                    'Bạn đã chi ${CurrencyFormatter.format(cat.amount)} cho ${cat.categoryName} tháng này, cao hơn $percent% so với tháng trước (${CurrencyFormatter.format(lastAmount)}).',
                severity: InsightSeverity.warning,
                createdAt: now,
              ),
            );
          }
        }
      }
    }

    // --- Rule 2: Budget Risk Warning ---
    if (currentBudget != null && currentBudget.forecast != null) {
      final forecast = currentBudget.forecast!;
      if (forecast.isOverBudgetRisk) {
        insights.add(
          InsightEntity(
            id: IdGenerator.generate(),
            type: 'budget_risk',
            title: 'Cảnh báo nguy cơ vượt ngân sách',
            message:
                'Với tốc độ chi tiêu hiện tại, dự kiến bạn sẽ vượt ngân sách ${CurrencyFormatter.format(forecast.projectedVariance)} vào cuối tháng.',
            severity: InsightSeverity.critical,
            createdAt: now,
          ),
        );
      }
    }

    // --- Rule 3: Upcoming Subscription Renewals ---
    for (final sub in subscriptions) {
      if (sub.isDueSoon) {
        insights.add(
          InsightEntity(
            id: IdGenerator.generate(),
            type: 'upcoming_subscription',
            title: 'Gói ${sub.name} sắp gia hạn',
            message:
                'Gói ${sub.name} sẽ tự động trừ ${CurrencyFormatter.format(sub.amount)} vào ngày ${DateFormatter.formatDate(sub.nextBillingDate)} (còn ${sub.daysUntilRenewal} ngày).',
            severity: InsightSeverity.info,
            createdAt: now,
          ),
        );
      }
    }

    // --- Rule 4: Savings Rate Achievement (>=30%) ---
    if (thisMonthAnalytics != null &&
        thisMonthAnalytics.totalIncome > 0 &&
        thisMonthAnalytics.savingsRate >= 30.0) {
      insights.add(
        InsightEntity(
          id: IdGenerator.generate(),
          type: 'savings_achievement',
          title:
              'Xuất sắc! Tỷ lệ tiết kiệm ${thisMonthAnalytics.savingsRate.toStringAsFixed(1)}%',
          message:
              'Bạn đang duy trì kỷ luật tài chính rất tốt! Đã tiết kiệm được ${CurrencyFormatter.format(thisMonthAnalytics.netSavings)} trong tháng này.',
          severity: InsightSeverity.positive,
          createdAt: now,
        ),
      );
    }

    // --- Rule 5: Low Wallet Balance (<100k) ---
    for (final wallet in wallets) {
      if (!wallet.isArchived &&
          !wallet.isExcludedFromTotal &&
          wallet.balance < 100000.0) {
        insights.add(
          InsightEntity(
            id: IdGenerator.generate(),
            type: 'low_balance',
            title: 'Số dư ví "${wallet.name}" sắp hết',
            message:
                'Ví "${wallet.name}" hiện chỉ còn ${CurrencyFormatter.format(wallet.balance)}. Hãy nạp thêm tiền để đảm bảo các khoản chi không bị gián đoạn.',
            severity: InsightSeverity.warning,
            createdAt: now,
          ),
        );
      }
    }

    return insights;
  }
}
