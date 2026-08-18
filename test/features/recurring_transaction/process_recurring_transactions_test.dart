import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:finly/features/recurring_transaction/data/repositories/recurring_transaction_repository_impl.dart';
import 'package:finly/features/recurring_transaction/domain/entities/recurring_transaction_entity.dart';
import 'package:finly/features/recurring_transaction/domain/usecases/process_due_recurring_transactions_usecase.dart';
import 'package:finly/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finly/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late RecurringTransactionRepositoryImpl recurringRepo;
  late TransactionRepositoryImpl txRepo;
  late AddTransactionUseCase addTxUseCase;
  late ProcessDueRecurringTransactionsUseCase processUseCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    recurringRepo = RecurringTransactionRepositoryImpl(db: db);
    txRepo = TransactionRepositoryImpl(db: db);
    addTxUseCase = AddTransactionUseCase(txRepo);
    processUseCase = ProcessDueRecurringTransactionsUseCase(
      recurringRepository: recurringRepo,
      addTransactionUseCase: addTxUseCase,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('ProcessDueRecurringTransactionsUseCase Tests', () {
    test(
      'Processes due monthly recurring transaction, deducts wallet balance, and advances next date',
      () async {
        // Cash initial: 2,500,000
        final initialWallet = await (db.select(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();
        expect(initialWallet.balance, equals(2500000.0));

        final pastDate = DateTime(2026, 8, 1);
        final recurring = RecurringTransactionEntity(
          id: 'rec_rent',
          type: 'expense',
          amount: 500000.0,
          walletId: 'wallet_default_cash',
          categoryId: 'cat_bills',
          note: 'Tiền internet',
          frequency: RecurringFrequency.monthly,
          startDate: pastDate,
          nextExecutionDate: pastDate,
          createdAt: pastDate,
          updatedAt: pastDate,
        );

        await recurringRepo.createRecurringTransaction(recurring);

        // Process due on August 18, 2026
        final processResult = await processUseCase(DateTime(2026, 8, 18));
        expect(processResult.isSuccess, isTrue);
        expect(processResult.dataOrNull, equals(1)); // 1 processed

        // Verify wallet balance is deducted (2,500,000 - 500,000 = 2,000,000)
        final updatedWallet = await (db.select(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();
        expect(updatedWallet.balance, equals(2000000.0));

        // Verify nextExecutionDate was advanced to next month (September 1, 2026)
        final allRecurring = await recurringRepo.getRecurringTransactions();
        final updatedRec = allRecurring.dataOrNull!.firstWhere(
          (r) => r.id == 'rec_rent',
        );
        expect(updatedRec.nextExecutionDate.month, equals(9));
        expect(updatedRec.nextExecutionDate.day, equals(1));
      },
    );
  });
}
