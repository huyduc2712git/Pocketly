import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_filter.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/usecases/add_transaction_usecase.dart';
import '../../domain/usecases/delete_transaction_usecase.dart';
import '../../domain/usecases/get_transactions_usecase.dart';
import '../../domain/usecases/update_transaction_usecase.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionRepositoryImpl(db: db);
});

final addTransactionUseCaseProvider = Provider<AddTransactionUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return AddTransactionUseCase(repository);
});

final updateTransactionUseCaseProvider = Provider<UpdateTransactionUseCase>((
  ref,
) {
  final repository = ref.watch(transactionRepositoryProvider);
  return UpdateTransactionUseCase(repository);
});

final deleteTransactionUseCaseProvider = Provider<DeleteTransactionUseCase>((
  ref,
) {
  final repository = ref.watch(transactionRepositoryProvider);
  return DeleteTransactionUseCase(repository);
});

final getTransactionsUseCaseProvider = Provider<GetTransactionsUseCase>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return GetTransactionsUseCase(repository);
});

// Active filter state
final transactionFilterProvider = StateProvider<TransactionFilter>((ref) {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
  return TransactionFilter(startDate: startOfMonth, endDate: endOfMonth);
});

// Real-time Stream of filtered transactions
final transactionsStreamProvider = StreamProvider<List<TransactionEntity>>((
  ref,
) {
  final useCase = ref.watch(getTransactionsUseCaseProvider);
  final filter = ref.watch(transactionFilterProvider);
  return useCase.watch(filter: filter);
});

class TransactionsController extends StateNotifier<AsyncValue<void>> {
  final AddTransactionUseCase addUseCase;
  final UpdateTransactionUseCase updateUseCase;
  final DeleteTransactionUseCase deleteUseCase;

  TransactionsController({
    required this.addUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  }) : super(const AsyncValue.data(null));

  Future<bool> addTransaction(TransactionEntity transaction) async {
    state = const AsyncValue.loading();
    final result = await addUseCase(transaction);
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

  Future<bool> updateTransaction({
    required TransactionEntity oldTransaction,
    required TransactionEntity newTransaction,
  }) async {
    state = const AsyncValue.loading();
    final result = await updateUseCase(
      oldTransaction: oldTransaction,
      newTransaction: newTransaction,
    );
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

  Future<bool> deleteTransaction(TransactionEntity transaction) async {
    state = const AsyncValue.loading();
    final result = await deleteUseCase(transaction);
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
}

final transactionsControllerProvider =
    StateNotifierProvider<TransactionsController, AsyncValue<void>>((ref) {
      final addUseCase = ref.watch(addTransactionUseCaseProvider);
      final updateUseCase = ref.watch(updateTransactionUseCaseProvider);
      final deleteUseCase = ref.watch(deleteTransactionUseCaseProvider);

      return TransactionsController(
        addUseCase: addUseCase,
        updateUseCase: updateUseCase,
        deleteUseCase: deleteUseCase,
      );
    });
