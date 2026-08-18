import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:finly/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finly/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finly/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:finly/features/transaction/domain/usecases/update_transaction_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepositoryImpl repository;
  late AddTransactionUseCase addUseCase;
  late UpdateTransactionUseCase updateUseCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = TransactionRepositoryImpl(db: db);
    addUseCase = AddTransactionUseCase(repository);
    updateUseCase = UpdateTransactionUseCase(repository);
  });

  tearDown(() async {
    await db.close();
  });

  group('UpdateTransactionUseCase Tests', () {
    test('Updating expense amount reverses old amount and applies new amount', () async {
      // 1. Add expense 200k on Cash (2,500k -> 2,300k)
      final oldTx = TransactionEntity(
        id: 'tx_update_test',
        type: 'expense',
        amount: 200000.0,
        walletId: 'wallet_default_cash',
        occurredAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await addUseCase(oldTx);

      var wallet = await (db.select(db.walletsTable)..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();
      expect(wallet.balance, equals(2300000.0));

      // 2. Update to 500k expense
      final newTx = oldTx.copyWith(amount: 500000.0);
      final result = await updateUseCase(oldTransaction: oldTx, newTransaction: newTx);
      expect(result.isSuccess, isTrue);

      wallet = await (db.select(db.walletsTable)..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();
      expect(wallet.balance, equals(2000000.0)); // 2,500,000 - 500,000
    });
  });
}
