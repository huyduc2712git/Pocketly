import '../../../../core/result/result.dart';
import '../repositories/sync_repository.dart';

class ProcessSyncQueueUseCase {
  final SyncRepository _syncRepository;

  const ProcessSyncQueueUseCase(this._syncRepository);

  Future<Result<int>> call({bool simulateNetworkFailure = false}) async {
    final pendingResult = await _syncRepository.getPendingTasks();
    if (pendingResult.isFailure) {
      return Result.failure(pendingResult.failureOrNull!);
    }

    final tasks = pendingResult.dataOrNull!;
    int syncedCount = 0;

    for (final task in tasks) {
      if (!task.canRetry) continue;

      await _syncRepository.markTaskSyncing(task.id);

      if (simulateNetworkFailure) {
        await _syncRepository.markTaskFailed(
          id: task.id,
          error: 'Không có kết nối mạng (SocketException)',
        );
      } else {
        // Successful sync simulation / REST push
        await _syncRepository.markTaskSynced(task.id);
        syncedCount++;
      }
    }

    return Result.success(syncedCount);
  }
}
