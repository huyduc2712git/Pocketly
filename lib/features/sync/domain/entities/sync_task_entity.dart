enum SyncStatus {
  pending,
  syncing,
  synced,
  failed;

  static SyncStatus fromString(String val) {
    switch (val.toLowerCase()) {
      case 'syncing':
        return SyncStatus.syncing;
      case 'synced':
        return SyncStatus.synced;
      case 'failed':
        return SyncStatus.failed;
      case 'pending':
      default:
        return SyncStatus.pending;
    }
  }
}

class SyncTaskEntity {
  final String id;
  final String
  entityType; // 'wallet', 'transaction', 'budget', 'subscription', 'category'
  final String entityId;
  final String operation; // 'create', 'update', 'delete', 'create_or_update'
  final String payload;
  final SyncStatus status;
  final int retryCount;
  final String? lastError;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SyncTaskEntity({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    this.status = SyncStatus.pending,
    this.retryCount = 0,
    this.lastError,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get canRetry => retryCount < 5 && status != SyncStatus.synced;

  SyncTaskEntity copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    SyncStatus? status,
    int? retryCount,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SyncTaskEntity(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
