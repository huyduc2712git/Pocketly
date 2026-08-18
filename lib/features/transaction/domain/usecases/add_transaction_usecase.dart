import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class AddTransactionUseCase {
  final TransactionRepository _repository;

  const AddTransactionUseCase(this._repository);

  Future<Result<TransactionEntity>> call(TransactionEntity transaction) async {
    if (transaction.amount <= 0) {
      return const Result.failure(
        ValidationFailure(message: 'Số tiền giao dịch phải lớn hơn 0.'),
      );
    }

    if (transaction.walletId.isEmpty) {
      return const Result.failure(
        ValidationFailure(message: 'Vui lòng chọn ví tiền cho giao dịch.'),
      );
    }

    if (transaction.type == 'transfer') {
      if (transaction.toWalletId == null || transaction.toWalletId!.isEmpty) {
        return const Result.failure(
          ValidationFailure(message: 'Vui lòng chọn ví nhận tiền.'),
        );
      }
      if (transaction.walletId == transaction.toWalletId) {
        return const Result.failure(
          ValidationFailure(
            message: 'Ví chuyển và ví nhận không được trùng nhau.',
          ),
        );
      }
    }

    return _repository.addTransaction(transaction);
  }
}
