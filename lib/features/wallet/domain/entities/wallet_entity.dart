enum WalletType {
  cash,
  bank,
  ewallet,
  credit,
  savings;

  String get displayName {
    switch (this) {
      case WalletType.cash:
        return 'Tiền mặt';
      case WalletType.bank:
        return 'Tài khoản Ngân hàng';
      case WalletType.ewallet:
        return 'Ví điện tử';
      case WalletType.credit:
        return 'Thẻ tín dụng';
      case WalletType.savings:
        return 'Sổ tiết kiệm';
    }
  }

  static WalletType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'bank':
        return WalletType.bank;
      case 'ewallet':
        return WalletType.ewallet;
      case 'credit':
        return WalletType.credit;
      case 'savings':
        return WalletType.savings;
      case 'cash':
      default:
        return WalletType.cash;
    }
  }
}

class WalletEntity {
  final String id;
  final String? userId;
  final String name;
  final WalletType type;
  final double balance;
  final String currency;
  final String? icon;
  final String? color;
  final bool isArchived;
  final bool isExcludedFromTotal;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WalletEntity({
    required this.id,
    this.userId,
    required this.name,
    required this.type,
    required this.balance,
    this.currency = 'VND',
    this.icon,
    this.color,
    this.isArchived = false,
    this.isExcludedFromTotal = false,
    this.syncStatus = 'synced',
    required this.createdAt,
    required this.updatedAt,
  });

  WalletEntity copyWith({
    String? id,
    String? userId,
    String? name,
    WalletType? type,
    double? balance,
    String? currency,
    String? icon,
    String? color,
    bool? isArchived,
    bool? isExcludedFromTotal,
    String? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isArchived: isArchived ?? this.isArchived,
      isExcludedFromTotal: isExcludedFromTotal ?? this.isExcludedFromTotal,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          balance == other.balance &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ balance.hashCode ^ name.hashCode;
}
