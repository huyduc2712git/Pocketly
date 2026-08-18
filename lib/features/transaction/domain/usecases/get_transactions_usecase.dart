import '../../../../core/result/result.dart';
import '../entities/transaction_entity.dart';
import '../entities/transaction_filter.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository _repository;

  const GetTransactionsUseCase(this._repository);

  Stream<List<TransactionEntity>> watch({TransactionFilter? filter}) {
    return _repository.watchTransactions(filter: filter);
  }

  Future<Result<List<TransactionEntity>>> call({TransactionFilter? filter}) {
    return _repository.getTransactions(filter: filter);
  }
}
