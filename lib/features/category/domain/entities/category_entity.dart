class CategoryEntity {
  final String id;
  final String name;
  final String type; // 'expense' or 'income'
  final String icon;
  final String color;
  final String? parentId;
  final bool isSystem;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.parentId,
    this.isSystem = false,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? type,
    String? icon,
    String? color,
    String? parentId,
    bool? isSystem,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      parentId: parentId ?? this.parentId,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
