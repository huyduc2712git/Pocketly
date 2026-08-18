enum RecurringFrequency { daily, weekly, monthly, yearly }

class RecurringTransactionEntity {
  final String id;
  final String type; // 'expense', 'income', 'transfer'
  final double amount;
  final String currency;
  final String walletId;
  final String? toWalletId;
  final String? categoryId;
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
    this.toWalletId,
    this.categoryId,
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
}
