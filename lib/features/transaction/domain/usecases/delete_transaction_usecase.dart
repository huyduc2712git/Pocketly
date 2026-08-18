import '../../../../core/result/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class DeleteTransactionUseCase {
  final TransactionRepository _repository;

  const DeleteTransactionUseCase(this._repository);

  Future<Result<void>> call(TransactionEntity transaction) async {
    return _repository.deleteTransaction(transaction);
  }
}
