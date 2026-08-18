class TransactionFilter {
  final String? walletId;
  final String? categoryId;
  final String? type; // 'expense', 'income', 'transfer'
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const TransactionFilter({
    this.walletId,
    this.categoryId,
    this.type,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  TransactionFilter copyWith({
    String? walletId,
    String? categoryId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    bool clearWallet = false,
    bool clearCategory = false,
    bool clearType = false,
  }) {
    return TransactionFilter(
      walletId: clearWallet ? null : (walletId ?? this.walletId),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      type: clearType ? null : (type ?? this.type),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
