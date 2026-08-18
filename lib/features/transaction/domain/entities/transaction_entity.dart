class TransactionEntity {
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
  final DateTime occurredAt;
  final String? metadata;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionEntity({
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
    required this.occurredAt,
    this.metadata,
    this.syncStatus = 'pending',
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';
  bool get isTransfer => type == 'transfer';

  TransactionEntity copyWith({
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
    DateTime? occurredAt,
    String? metadata,
    String? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionEntity(
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
      occurredAt: occurredAt ?? this.occurredAt,
      metadata: metadata ?? this.metadata,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          occurredAt == other.occurredAt;

  @override
  int get hashCode => id.hashCode ^ amount.hashCode ^ occurredAt.hashCode;
}
