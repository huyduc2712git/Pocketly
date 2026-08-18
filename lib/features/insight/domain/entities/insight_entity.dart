enum InsightType {
  spendingSpike,
  budgetExceeded,
  budgetForecastExceeded,
  unusualTransaction,
  lowBalance,
  highDailySpend,
  monthlySavingProgress,
  subscriptionDetected,
}

enum InsightSeverity { info, warning, critical, positive }

class InsightEntity {
  final String id;
  final InsightType type;
  final String title;
  final String message;
  final InsightSeverity severity;
  final Map<String, dynamic>? metadata;
  final bool isDismissed;
  final DateTime createdAt;

  const InsightEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.severity = InsightSeverity.info,
    this.metadata,
    this.isDismissed = false,
    required this.createdAt,
  });
}
