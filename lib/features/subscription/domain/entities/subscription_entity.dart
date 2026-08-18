enum SubscriptionCycle { weekly, monthly, yearly }

class SubscriptionEntity {
  final String id;
  final String name;
  final double amount;
  final String currency;
  final String? icon;
  final String walletId;
  final String? categoryId;
  final SubscriptionCycle billingCycle;
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
    this.categoryId,
    this.billingCycle = SubscriptionCycle.monthly,
    required this.nextBillingDate,
    this.isActive = true,
    this.remindDaysBefore = 2,
    required this.createdAt,
    required this.updatedAt,
  });

  double get monthlyCost {
    switch (billingCycle) {
      case SubscriptionCycle.weekly:
        return amount * 4.33;
      case SubscriptionCycle.monthly:
        return amount;
      case SubscriptionCycle.yearly:
        return amount / 12;
    }
  }

  double get yearlyCost {
    switch (billingCycle) {
      case SubscriptionCycle.weekly:
        return amount * 52;
      case SubscriptionCycle.monthly:
        return amount * 12;
      case SubscriptionCycle.yearly:
        return amount;
    }
  }
}
