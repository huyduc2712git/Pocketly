import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository _repository;

  const UpdateTransactionUseCase(this._repository);

  Future<Result<TransactionEntity>> call({
    required TransactionEntity oldTransaction,
    required TransactionEntity newTransaction,
  }) async {
    if (newTransaction.amount <= 0) {
      return const Result.failure(
        ValidationFailure(message: 'Số tiền giao dịch phải lớn hơn 0.'),
      );
    }

    if (newTransaction.walletId.isEmpty) {
      return const Result.failure(
        ValidationFailure(message: 'Vui lòng chọn ví tiền cho giao dịch.'),
      );
    }

    if (newTransaction.type == 'transfer') {
      if (newTransaction.toWalletId == null || newTransaction.toWalletId!.isEmpty) {
        return const Result.failure(
          ValidationFailure(message: 'Vui lòng chọn ví nhận tiền.'),
        );
      }
      if (newTransaction.walletId == newTransaction.toWalletId) {
        return const Result.failure(
          ValidationFailure(message: 'Ví chuyển và ví nhận không được trùng nhau.'),
        );
      }
    }

    return _repository.updateTransaction(
      oldTransaction: oldTransaction,
      newTransaction: newTransaction,
    );
  }
}
