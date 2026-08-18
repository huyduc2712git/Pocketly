import '../../../../core/result/result.dart';
import '../entities/transaction_entity.dart';
import '../entities/transaction_filter.dart';

abstract class TransactionRepository {
  Stream<List<TransactionEntity>> watchTransactions({TransactionFilter? filter});
  Future<Result<List<TransactionEntity>>> getTransactions({TransactionFilter? filter});
  Future<Result<TransactionEntity>> getTransactionById(String id);
  Future<Result<TransactionEntity>> addTransaction(TransactionEntity transaction);
  Future<Result<TransactionEntity>> updateTransaction({
    required TransactionEntity oldTransaction,
    required TransactionEntity newTransaction,
  });
  Future<Result<void>> deleteTransaction(TransactionEntity transaction);
}
