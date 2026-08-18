import '../../../../core/result/result.dart';
import '../entities/sync_task_entity.dart';

abstract class SyncRepository {
  Stream<List<SyncTaskEntity>> watchPendingTasks();
  Future<Result<List<SyncTaskEntity>>> getPendingTasks();
  Future<Result<void>> markTaskSyncing(String id);
  Future<Result<void>> markTaskSynced(String id);
  Future<Result<void>> markTaskFailed({required String id, required String error});
  Future<Result<void>> clearCompletedTasks();
}
