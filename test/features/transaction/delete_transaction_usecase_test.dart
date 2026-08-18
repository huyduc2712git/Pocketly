import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:finly/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finly/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finly/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:finly/features/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepositoryImpl repository;
  late AddTransactionUseCase addUseCase;
  late DeleteTransactionUseCase deleteUseCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = TransactionRepositoryImpl(db: db);
    addUseCase = AddTransactionUseCase(repository);
    deleteUseCase = DeleteTransactionUseCase(repository);
  });

  tearDown(() async {
    await db.close();
  });

  group('DeleteTransactionUseCase & Balance Reversal Tests', () {
    test('Deleting Expense restores wallet balance', () async {
      // 1. Add expense
      final tx = TransactionEntity(
        id: 'tx_expense_del',
        type: 'expense',
        amount: 500000.0,
        walletId: 'wallet_default_cash', // 2,500,000 -> 2,000,000
        occurredAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await addUseCase(tx);

      var wallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();
      expect(wallet.balance, equals(2000000.0));

      // 2. Delete expense
      final result = await deleteUseCase(tx);
      expect(result.isSuccess, isTrue);

      wallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();
      expect(
        wallet.balance,
        equals(2500000.0),
      ); // Balance reversed back to 2,500,000
    });

    test('Deleting Income reduces wallet balance', () async {
      // 1. Add income
      final tx = TransactionEntity(
        id: 'tx_income_del',
        type: 'income',
        amount: 1000000.0,
        walletId: 'wallet_default_cash', // 2,500,000 -> 3,500,000
        occurredAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await addUseCase(tx);

      // 2. Delete income
      final result = await deleteUseCase(tx);
      expect(result.isSuccess, isTrue);

      final wallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();
      expect(wallet.balance, equals(2500000.0)); // Restored back
    });

    test(
      'Deleting Transfer reverses both source and destination balances',
      () async {
        // 1. Add transfer: Bank (15,800,000) -> Cash (2,500,000), amount: 1,000,000
        final tx = TransactionEntity(
          id: 'tx_transfer_del',
          type: 'transfer',
          amount: 1000000.0,
          walletId: 'wallet_bank_primary',
          toWalletId: 'wallet_default_cash',
          occurredAt: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await addUseCase(tx);

        // 2. Delete transfer
        final result = await deleteUseCase(tx);
        expect(result.isSuccess, isTrue);

        final bank = await (db.select(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals('wallet_bank_primary'))).getSingle();
        final cash = await (db.select(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();

        expect(bank.balance, equals(15800000.0));
        expect(cash.balance, equals(2500000.0));
      },
    );
  });
}
