import '../../../../core/result/result.dart';
import '../entities/recurring_transaction_entity.dart';

abstract class RecurringTransactionRepository {
  Stream<List<RecurringTransactionEntity>> watchRecurringTransactions();
  Future<Result<List<RecurringTransactionEntity>>> getRecurringTransactions();
  Future<Result<RecurringTransactionEntity>> createRecurringTransaction(RecurringTransactionEntity entity);
  Future<Result<RecurringTransactionEntity>> updateRecurringTransaction(RecurringTransactionEntity entity);
  Future<Result<void>> deleteRecurringTransaction(String id);
}
