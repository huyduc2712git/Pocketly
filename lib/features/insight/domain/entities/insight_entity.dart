enum InsightSeverity {
  info,
  warning,
  critical,
  positive;

  static InsightSeverity fromString(String val) {
    switch (val.toLowerCase()) {
      case 'warning':
        return InsightSeverity.warning;
      case 'critical':
        return InsightSeverity.critical;
      case 'positive':
        return InsightSeverity.positive;
      case 'info':
      default:
        return InsightSeverity.info;
    }
  }
}

class InsightEntity {
  final String id;
  final String type; // 'category_spike', 'budget_risk', 'upcoming_subscription', 'savings_achievement', 'low_balance'
  final String title;
  final String message;
  final InsightSeverity severity;
  final String? metadata;
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

  InsightEntity copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    InsightSeverity? severity,
    String? metadata,
    bool? isDismissed,
    DateTime? createdAt,
  }) {
    return InsightEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      metadata: metadata ?? this.metadata,
      isDismissed: isDismissed ?? this.isDismissed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
