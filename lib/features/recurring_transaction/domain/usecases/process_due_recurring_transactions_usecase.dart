import '../../../../core/result/result.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../transaction/domain/usecases/add_transaction_usecase.dart';
import '../repositories/recurring_transaction_repository.dart';

class ProcessDueRecurringTransactionsUseCase {
  final RecurringTransactionRepository recurringRepository;
  final AddTransactionUseCase addTransactionUseCase;

  const ProcessDueRecurringTransactionsUseCase({
    required this.recurringRepository,
    required this.addTransactionUseCase,
  });

  Future<Result<int>> call([DateTime? currentTime]) async {
    final now = currentTime ?? DateTime.now();
    final allResult = await recurringRepository.getRecurringTransactions();
    if (allResult.isFailure) {
      return Result.failure(allResult.failureOrNull!);
    }

    final recurringList = allResult.dataOrNull!;
    int processedCount = 0;

    for (final item in recurringList) {
      if (item.isDue(now)) {
        // 1. Create real transaction
        final newTx = TransactionEntity(
          id: IdGenerator.generate(),
          type: item.type,
          amount: item.amount,
          currency: item.currency,
          walletId: item.walletId,
          toWalletId: item.toWalletId,
          categoryId: item.categoryId,
          note: item.note != null ? '${item.note} (Định kỳ)' : 'Giao dịch định kỳ',
          occurredAt: item.nextExecutionDate,
          createdAt: now,
          updatedAt: now,
        );

        final addResult = await addTransactionUseCase(newTx);
        if (addResult.isSuccess) {
          // 2. Advance next execution date
          final nextDate = item.frequency.calculateNextDate(
            item.nextExecutionDate,
            interval: item.interval,
          );

          final bool shouldDeactivate =
              item.endDate != null && nextDate.isAfter(item.endDate!);

          await recurringRepository.updateRecurringTransaction(
            item.copyWith(
              nextExecutionDate: nextDate,
              isActive: !shouldDeactivate,
              updatedAt: now,
            ),
          );

          processedCount++;
        }
      }
    }

    return Result.success(processedCount);
  }
}
