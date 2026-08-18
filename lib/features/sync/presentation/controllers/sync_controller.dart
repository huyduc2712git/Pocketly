import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/sync_repository_impl.dart';
import '../../domain/entities/sync_task_entity.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../domain/usecases/process_sync_queue_usecase.dart';

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SyncRepositoryImpl(db: db);
});

final processSyncQueueUseCaseProvider = Provider<ProcessSyncQueueUseCase>((
  ref,
) {
  final repo = ref.watch(syncRepositoryProvider);
  return ProcessSyncQueueUseCase(repo);
});

final pendingSyncTasksStreamProvider = StreamProvider<List<SyncTaskEntity>>((
  ref,
) {
  final repo = ref.watch(syncRepositoryProvider);
  return repo.watchPendingTasks();
});

final pendingSyncCountProvider = Provider<int>((ref) {
  final tasksAsync = ref.watch(pendingSyncTasksStreamProvider);
  return tasksAsync.maybeWhen(data: (tasks) => tasks.length, orElse: () => 0);
});

class SyncController extends StateNotifier<AsyncValue<void>> {
  final ProcessSyncQueueUseCase _useCase;

  SyncController(this._useCase) : super(const AsyncValue.data(null));

  Future<int> syncNow({bool simulateFailure = false}) async {
    state = const AsyncValue.loading();
    final result = await _useCase(simulateNetworkFailure: simulateFailure);
    state = const AsyncValue.data(null);
    return result.dataOrNull ?? 0;
  }
}

final syncControllerProvider =
    StateNotifierProvider<SyncController, AsyncValue<void>>((ref) {
      final useCase = ref.watch(processSyncQueueUseCaseProvider);
      return SyncController(useCase);
    });
