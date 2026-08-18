import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:finly/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finly/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finly/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepositoryImpl repository;
  late AddTransactionUseCase useCase;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = TransactionRepositoryImpl(db: db);
    useCase = AddTransactionUseCase(repository);
  });

  tearDown(() async {
    await db.close();
  });

  group('AddTransactionUseCase & Atomic Balance Tests', () {
    test('Validation fails when amount is 0 or negative', () async {
      final tx = TransactionEntity(
        id: 'tx_invalid',
        type: 'expense',
        amount: 0.0,
        walletId: 'wallet_default_cash',
        occurredAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await useCase(tx);
      expect(result.isFailure, isTrue);
    });

    test(
      'Validation fails when transfer destination is same as source',
      () async {
        final tx = TransactionEntity(
          id: 'tx_invalid_transfer',
          type: 'transfer',
          amount: 100000.0,
          walletId: 'wallet_default_cash',
          toWalletId: 'wallet_default_cash',
          occurredAt: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final result = await useCase(tx);
        expect(result.isFailure, isTrue);
      },
    );

    test('Adding Expense deducts exact amount from source wallet', () async {
      // Cash initial balance seeded as 2,500,000
      final initialWallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();
      expect(initialWallet.balance, equals(2500000.0));

      final tx = TransactionEntity(
        id: 'tx_expense_1',
        type: 'expense',
        amount: 350000.0,
        walletId: 'wallet_default_cash',
        categoryId: 'cat_food',
        note: 'Ăn tối',
        occurredAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await useCase(tx);
      expect(result.isSuccess, isTrue);

      final updatedWallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();
      expect(updatedWallet.balance, equals(2150000.0)); // 2,500,000 - 350,000
    });

    test('Adding Income adds exact amount to wallet', () async {
      // Bank initial balance seeded as 15,800,000
      final tx = TransactionEntity(
        id: 'tx_income_1',
        type: 'income',
        amount: 5000000.0,
        walletId: 'wallet_bank_primary',
        categoryId: 'cat_salary',
        note: 'Thưởng quý',
        occurredAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await useCase(tx);
      expect(result.isSuccess, isTrue);

      final updatedWallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals('wallet_bank_primary'))).getSingle();
      expect(
        updatedWallet.balance,
        equals(20800000.0),
      ); // 15,800,000 + 5,000,000
    });

    test(
      'Adding Transfer deducts from source and adds to destination',
      () async {
        // Bank (15,800,000) -> Cash (2,500,000)
        final tx = TransactionEntity(
          id: 'tx_transfer_1',
          type: 'transfer',
          amount: 2000000.0,
          walletId: 'wallet_bank_primary',
          toWalletId: 'wallet_default_cash',
          occurredAt: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final result = await useCase(tx);
        expect(result.isSuccess, isTrue);

        final sourceWallet = await (db.select(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals('wallet_bank_primary'))).getSingle();
        final destWallet = await (db.select(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals('wallet_default_cash'))).getSingle();

        expect(
          sourceWallet.balance,
          equals(13800000.0),
        ); // 15,800,000 - 2,000,000
        expect(destWallet.balance, equals(4500000.0)); // 2,500,000 + 2,000,000
      },
    );
  });
}
