import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/sync_task_entity.dart';
import '../../domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final AppDatabase db;

  SyncRepositoryImpl({required this.db});

  SyncTaskEntity _toEntity(SyncQueueRow row) {
    return SyncTaskEntity(
      id: row.id,
      entityType: row.entityType,
      entityId: row.entityId,
      operation: row.operation,
      payload: row.payload,
      status: SyncStatus.fromString(row.status),
      retryCount: row.retryCount,
      lastError: row.lastError,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  @override
  Stream<List<SyncTaskEntity>> watchPendingTasks() {
    return (db.select(db.syncQueueTable)
          ..where((tbl) => tbl.status.equals('pending') | tbl.status.equals('failed'))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<Result<List<SyncTaskEntity>>> getPendingTasks() async {
    try {
      final rows = await (db.select(db.syncQueueTable)
            ..where((tbl) => tbl.status.equals('pending') | tbl.status.equals('failed'))
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
          .get();
      return Result.success(rows.map(_toEntity).toList());
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> markTaskSyncing(String id) async {
    try {
      await (db.update(db.syncQueueTable)..where((tbl) => tbl.id.equals(id))).write(
        SyncQueueTableCompanion(
          status: const Value('syncing'),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> markTaskSynced(String id) async {
    try {
      await (db.update(db.syncQueueTable)..where((tbl) => tbl.id.equals(id))).write(
        SyncQueueTableCompanion(
          status: const Value('synced'),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> markTaskFailed({required String id, required String error}) async {
    try {
      final current = await (db.select(db.syncQueueTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      final newRetryCount = (current?.retryCount ?? 0) + 1;
      final status = newRetryCount >= 5 ? 'failed' : 'pending';

      await (db.update(db.syncQueueTable)..where((tbl) => tbl.id.equals(id))).write(
        SyncQueueTableCompanion(
          status: Value(status),
          retryCount: Value(newRetryCount),
          lastError: Value(error),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> clearCompletedTasks() async {
    try {
      await (db.delete(db.syncQueueTable)..where((tbl) => tbl.status.equals('synced'))).go();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }
}
