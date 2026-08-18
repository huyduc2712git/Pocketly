import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:finly/core/utils/currency_formatter.dart';
import 'package:finly/features/budget/domain/entities/budget_entity.dart';
import 'package:finly/features/budget/domain/usecases/calculate_budget_forecast_usecase.dart';
import 'package:finly/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finly/features/transaction/domain/entities/transaction_entity.dart';
import 'package:finly/features/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:finly/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepositoryImpl txRepo;
  late AddTransactionUseCase addTxUseCase;
  late WalletRepositoryImpl walletRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    txRepo = TransactionRepositoryImpl(db: db);
    addTxUseCase = AddTransactionUseCase(txRepo);
    walletRepo = WalletRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Financial Edge Cases & Arithmetic Precision Tests', () {
    test('1. Zero and Negative Amounts are strictly rejected by AddTransactionUseCase', () async {
      final now = DateTime.now();

      final zeroTx = TransactionEntity(
        id: 'tx_zero',
        type: 'expense',
        amount: 0.0,
        walletId: 'wallet_default_cash',
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      );
      final zeroResult = await addTxUseCase(zeroTx);
      expect(zeroResult.isFailure, isTrue);

      final negTx = TransactionEntity(
        id: 'tx_neg',
        type: 'income',
        amount: -50000.0,
        walletId: 'wallet_default_cash',
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      );
      final negResult = await addTxUseCase(negTx);
      expect(negResult.isFailure, isTrue);
    });

    test('2. Same-wallet transfer is rejected as an invalid operation', () async {
      final now = DateTime.now();
      final transferSame = TransactionEntity(
        id: 'tx_same_transfer',
        type: 'transfer',
        amount: 100000.0,
        walletId: 'wallet_default_cash',
        toWalletId: 'wallet_default_cash', // Destination same as source
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      );
      final result = await addTxUseCase(transferSame);
      expect(result.isFailure, isTrue);
    });

    test('3. Large financial values (Billions VND) retain exact precision without floating point drift', () async {
      final now = DateTime.now();
      // 50,000,000,000 VND
      const largeAmount = 50000000000.0;

      final largeTx = TransactionEntity(
        id: 'tx_large',
        type: 'income',
        amount: largeAmount,
        walletId: 'wallet_bank_primary',
        occurredAt: now,
        createdAt: now,
        updatedAt: now,
      );

      final result = await addTxUseCase(largeTx);
      expect(result.isSuccess, isTrue);

      final bankWallet = await (db.select(db.walletsTable)..where((tbl) => tbl.id.equals('wallet_bank_primary'))).getSingle();
      // Initial bank balance 15,800,000 + 50,000,000,000 = 50,015,800,000.0
      expect(bankWallet.balance, equals(50015800000.0));
      expect(CurrencyFormatter.format(largeAmount), contains('50.000.000.000'));
      expect(CurrencyFormatter.formatCompact(largeAmount), equals('50B ₫'));
    });

    test('4. Leap year February (29 days) and 31-day month boundaries in Forecast Engine', () {
      const forecastUseCase = CalculateBudgetForecastUseCase();

      // Leap year 2028 Feb has 29 days. On Day 10, spent 2,900,000
      final leapFeb = DateTime(2028, 2, 10);
      final budget2028 = BudgetEntity(
        id: 'b_leap',
        month: 2,
        year: 2028,
        totalLimit: 10000000.0,
        spentAmount: 2900000.0,
        createdAt: leapFeb,
        updatedAt: leapFeb,
      );

      final forecast = forecastUseCase(
        totalLimit: budget2028.totalLimit,
        spentSoFar: budget2028.spentAmount,
        month: budget2028.month,
        year: budget2028.year,
        currentDate: leapFeb,
      );
      expect(forecast.daysPassed, equals(10));
      expect(forecast.daysInMonth, equals(29));
      expect(forecast.dailyAverage, equals(290000.0));
      // Projected = 290,000 * 29 = 8,410,000
      expect(forecast.projectedMonthEndExpense, equals(8410000.0));
      expect(forecast.isOverBudgetRisk, isFalse);
    });

    test('5. Archived wallet is properly excluded from total active net worth', () async {
      final initialNetWorth = await walletRepo.getTotalNetWorth();
      // Default cash (2.5M) + Default bank (15.8M) = 18.3M
      expect(initialNetWorth.dataOrNull, equals(18300000.0));

      // Archive cash wallet
      await walletRepo.deleteWallet('wallet_default_cash');

      final updatedNetWorth = await walletRepo.getTotalNetWorth();
      // Only active bank wallet remains = 15,800,000
      expect(updatedNetWorth.dataOrNull, equals(15800000.0));
    });
  });
}
