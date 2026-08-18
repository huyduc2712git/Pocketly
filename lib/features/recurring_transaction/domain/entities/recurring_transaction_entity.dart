enum RecurringFrequency {
  daily,
  weekly,
  monthly,
  yearly;

  String get displayName {
    switch (this) {
      case RecurringFrequency.daily:
        return 'Hàng ngày';
      case RecurringFrequency.weekly:
        return 'Hàng tuần';
      case RecurringFrequency.monthly:
        return 'Hàng tháng';
      case RecurringFrequency.yearly:
        return 'Hàng năm';
    }
  }

  static RecurringFrequency fromString(String val) {
    switch (val.toLowerCase()) {
      case 'daily':
        return RecurringFrequency.daily;
      case 'weekly':
        return RecurringFrequency.weekly;
      case 'yearly':
        return RecurringFrequency.yearly;
      case 'monthly':
      default:
        return RecurringFrequency.monthly;
    }
  }

  DateTime calculateNextDate(DateTime fromDate, {int interval = 1}) {
    switch (this) {
      case RecurringFrequency.daily:
        return fromDate.add(Duration(days: interval));
      case RecurringFrequency.weekly:
        return fromDate.add(Duration(days: 7 * interval));
      case RecurringFrequency.monthly:
        return DateTime(fromDate.year, fromDate.month + interval, fromDate.day);
      case RecurringFrequency.yearly:
        return DateTime(fromDate.year + interval, fromDate.month, fromDate.day);
    }
  }
}

class RecurringTransactionEntity {
  final String id;
  final String type; // 'expense', 'income', 'transfer'
  final double amount;
  final String currency;
  final String walletId;
  final String? walletName;
  final String? toWalletId;
  final String? toWalletName;
  final String? categoryId;
  final String? categoryName;
  final String? categoryIcon;
  final String? categoryColor;
  final String? note;
  final RecurringFrequency frequency;
  final int interval;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime nextExecutionDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecurringTransactionEntity({
    required this.id,
    required this.type,
    required this.amount,
    this.currency = 'VND',
    required this.walletId,
    this.walletName,
    this.toWalletId,
    this.toWalletName,
    this.categoryId,
    this.categoryName,
    this.categoryIcon,
    this.categoryColor,
    this.note,
    required this.frequency,
    this.interval = 1,
    required this.startDate,
    this.endDate,
    required this.nextExecutionDate,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  bool isDue([DateTime? now]) {
    final current = now ?? DateTime.now();
    if (!isActive) return false;
    if (endDate != null && current.isAfter(endDate!)) return false;
    return nextExecutionDate.isBefore(current) ||
        (nextExecutionDate.year == current.year &&
            nextExecutionDate.month == current.month &&
            nextExecutionDate.day == current.day);
  }

  RecurringTransactionEntity copyWith({
    String? id,
    String? type,
    double? amount,
    String? currency,
    String? walletId,
    String? walletName,
    String? toWalletId,
    String? toWalletName,
    String? categoryId,
    String? categoryName,
    String? categoryIcon,
    String? categoryColor,
    String? note,
    RecurringFrequency? frequency,
    int? interval,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? nextExecutionDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecurringTransactionEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      walletId: walletId ?? this.walletId,
      walletName: walletName ?? this.walletName,
      toWalletId: toWalletId ?? this.toWalletId,
      toWalletName: toWalletName ?? this.toWalletName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColor: categoryColor ?? this.categoryColor,
      note: note ?? this.note,
      frequency: frequency ?? this.frequency,
      interval: interval ?? this.interval,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextExecutionDate: nextExecutionDate ?? this.nextExecutionDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
