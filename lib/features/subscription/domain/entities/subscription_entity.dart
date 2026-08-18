enum SubscriptionBillingCycle {
  weekly,
  monthly,
  yearly;

  String get displayName {
    switch (this) {
      case SubscriptionBillingCycle.weekly:
        return 'Hàng tuần';
      case SubscriptionBillingCycle.monthly:
        return 'Hàng tháng';
      case SubscriptionBillingCycle.yearly:
        return 'Hàng năm';
    }
  }

  static SubscriptionBillingCycle fromString(String val) {
    switch (val.toLowerCase()) {
      case 'weekly':
        return SubscriptionBillingCycle.weekly;
      case 'yearly':
        return SubscriptionBillingCycle.yearly;
      case 'monthly':
      default:
        return SubscriptionBillingCycle.monthly;
    }
  }

  double calculateMonthlyEquivalent(double amount) {
    switch (this) {
      case SubscriptionBillingCycle.weekly:
        return amount * 4.33;
      case SubscriptionBillingCycle.monthly:
        return amount;
      case SubscriptionBillingCycle.yearly:
        return amount / 12;
    }
  }
}

class SubscriptionEntity {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final String? icon;
  final String walletId;
  final String? walletName;
  final String? categoryId;
  final String? categoryName;
  final String? categoryColor;
  final SubscriptionBillingCycle billingCycle;
  final DateTime nextBillingDate;
  final bool isActive;
  final int remindDaysBefore;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubscriptionEntity({
    required this.id,
    required this.name,
    required this.amount,
    this.currency = 'VND',
    this.icon,
    required this.walletId,
    this.walletName,
    this.categoryId,
    this.categoryName,
    this.categoryColor,
    this.billingCycle = SubscriptionBillingCycle.monthly,
    required this.nextBillingDate,
    this.isActive = true,
    this.remindDaysBefore = 2,
    required this.createdAt,
    required this.updatedAt,
  });

  double get monthlyCost => billingCycle.calculateMonthlyEquivalent(amount);

  int get daysUntilRenewal {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(nextBillingDate.year, nextBillingDate.month, nextBillingDate.day);
    return target.difference(today).inDays;
  }

  bool get isDueSoon => isActive && daysUntilRenewal >= 0 && daysUntilRenewal <= remindDaysBefore;

  SubscriptionEntity copyWith({
    String? id,
    String? name,
    double? amount,
    String? currency,
    String? icon,
    String? walletId,
    String? walletName,
    String? categoryId,
    String? categoryName,
    String? categoryColor,
    SubscriptionBillingCycle? billingCycle,
    DateTime? nextBillingDate,
    bool? isActive,
    int? remindDaysBefore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      icon: icon ?? this.icon,
      walletId: walletId ?? this.walletId,
      walletName: walletName ?? this.walletName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryColor: categoryColor ?? this.categoryColor,
      billingCycle: billingCycle ?? this.billingCycle,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      isActive: isActive ?? this.isActive,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
