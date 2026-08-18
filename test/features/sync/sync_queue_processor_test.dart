import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:finly/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:finly/features/sync/domain/entities/sync_task_entity.dart';
import 'package:finly/features/sync/domain/usecases/process_sync_queue_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late SyncRepositoryImpl repository;
  late ProcessSyncQueueUseCase useCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = SyncRepositoryImpl(db: db);
    useCase = ProcessSyncQueueUseCase(repository);
  });

  tearDown(() async {
    await db.close();
  });

  group('SyncQueue Processor Tests', () {
    test('Process pending queue items successfully updates status to synced', () async {
      // 1. Insert a pending task into sync_queue
      await db.into(db.syncQueueTable).insert(
            SyncQueueTableCompanion.insert(
              id: 'task_1',
              entityType: 'transaction',
              entityId: 'tx_123',
              operation: 'create',
              payload: '{"id": "tx_123", "amount": 100000}',
              status: const Value('pending'),
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
            ),
          );

      var pendingList = await repository.getPendingTasks();
      expect(pendingList.dataOrNull!.length, equals(1));
      expect(pendingList.dataOrNull!.first.status, equals(SyncStatus.pending));

      // 2. Process sync
      final result = await useCase();
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(1));

      // 3. Verify no more pending tasks
      pendingList = await repository.getPendingTasks();
      expect(pendingList.dataOrNull!.isEmpty, isTrue);
    });

    test('Process with failure increments retry count and sets error message', () async {
      await db.into(db.syncQueueTable).insert(
            SyncQueueTableCompanion.insert(
              id: 'task_fail',
              entityType: 'wallet',
              entityId: 'wallet_1',
              operation: 'update',
              payload: '{"id": "wallet_1"}',
              status: const Value('pending'),
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
            ),
          );

      // Simulate failure
      final result = await useCase(simulateNetworkFailure: true);
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(0));

      final pendingList = await repository.getPendingTasks();
      expect(pendingList.dataOrNull!.length, equals(1));
      expect(pendingList.dataOrNull!.first.retryCount, equals(1));
      expect(pendingList.dataOrNull!.first.lastError, contains('SocketException'));
    });
  });
}
