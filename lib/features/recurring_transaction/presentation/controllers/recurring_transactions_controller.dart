import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../../transaction/presentation/controllers/transactions_controller.dart';
import '../../data/repositories/recurring_transaction_repository_impl.dart';
import '../../domain/entities/recurring_transaction_entity.dart';
import '../../domain/repositories/recurring_transaction_repository.dart';
import '../../domain/usecases/process_due_recurring_transactions_usecase.dart';

final recurringTransactionRepositoryProvider = Provider<RecurringTransactionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return RecurringTransactionRepositoryImpl(db: db);
});

final processDueRecurringTransactionsUseCaseProvider =
    Provider<ProcessDueRecurringTransactionsUseCase>((ref) {
  final recurringRepo = ref.watch(recurringTransactionRepositoryProvider);
  final addTxUseCase = ref.watch(addTransactionUseCaseProvider);
  return ProcessDueRecurringTransactionsUseCase(
    recurringRepository: recurringRepo,
    addTransactionUseCase: addTxUseCase,
  );
});

final recurringTransactionsStreamProvider =
    StreamProvider<List<RecurringTransactionEntity>>((ref) {
  final repo = ref.watch(recurringTransactionRepositoryProvider);
  return repo.watchRecurringTransactions();
});

class RecurringTransactionsController extends StateNotifier<AsyncValue<void>> {
  final RecurringTransactionRepository repository;
  final ProcessDueRecurringTransactionsUseCase processUseCase;

  RecurringTransactionsController({
    required this.repository,
    required this.processUseCase,
  }) : super(const AsyncValue.data(null));

  Future<bool> createRecurringTransaction(RecurringTransactionEntity entity) async {
    state = const AsyncValue.loading();
    final result = await repository.createRecurringTransaction(entity);
    return result.when(
      success: (_) {
        state = const AsyncValue.data(null);
        return true;
      },
      failure: (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
    );
  }

  Future<bool> toggleActive(RecurringTransactionEntity entity) async {
    final updated = entity.copyWith(isActive: !entity.isActive);
    final result = await repository.updateRecurringTransaction(updated);
    return result.isSuccess;
  }

  Future<bool> deleteRecurringTransaction(String id) async {
    state = const AsyncValue.loading();
    final result = await repository.deleteRecurringTransaction(id);
    return result.when(
      success: (_) {
        state = const AsyncValue.data(null);
        return true;
      },
      failure: (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
    );
  }

  Future<int> processDue() async {
    final result = await processUseCase();
    return result.dataOrNull ?? 0;
  }
}

final recurringTransactionsControllerProvider =
    StateNotifierProvider<RecurringTransactionsController, AsyncValue<void>>((ref) {
  final repo = ref.watch(recurringTransactionRepositoryProvider);
  final processUseCase = ref.watch(processDueRecurringTransactionsUseCaseProvider);
  return RecurringTransactionsController(
    repository: repo,
    processUseCase: processUseCase,
  );
});
