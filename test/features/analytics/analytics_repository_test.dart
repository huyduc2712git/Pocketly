import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:finly/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:finly/features/analytics/domain/entities/analytics_entity.dart';
import 'package:finly/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:finly/features/transaction/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepositoryImpl txRepository;
  late AnalyticsRepositoryImpl analyticsRepository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    txRepository = TransactionRepositoryImpl(db: db);
    analyticsRepository = AnalyticsRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AnalyticsRepositoryImpl Tests', () {
    test(
      'Calculates financial summary and excludes transfers from expense totals',
      () async {
        final now = DateTime.now();

        // 1. Add Income: 20,000,000
        await txRepository.addTransaction(
          TransactionEntity(
            id: 'tx_salary',
            type: 'income',
            amount: 20000000.0,
            walletId: 'wallet_bank_primary',
            categoryId: 'cat_salary',
            occurredAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        // 2. Add Expense 1: Food 2,000,000
        await txRepository.addTransaction(
          TransactionEntity(
            id: 'tx_food',
            type: 'expense',
            amount: 2000000.0,
            walletId: 'wallet_default_cash',
            categoryId: 'cat_food',
            occurredAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        // 3. Add Expense 2: Shopping 3,000,000
        await txRepository.addTransaction(
          TransactionEntity(
            id: 'tx_shop',
            type: 'expense',
            amount: 3000000.0,
            walletId: 'wallet_bank_primary',
            categoryId: 'cat_shopping',
            occurredAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        // 4. Add Transfer: 5,000,000 (Bank -> Cash)
        await txRepository.addTransaction(
          TransactionEntity(
            id: 'tx_trans',
            type: 'transfer',
            amount: 5000000.0,
            walletId: 'wallet_bank_primary',
            toWalletId: 'wallet_default_cash',
            occurredAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

        final result = await analyticsRepository.getAnalytics(
          AnalyticsPeriod.thisMonth,
        );
        expect(result.isSuccess, isTrue);

        final summary = result.dataOrNull!;
        expect(summary.totalIncome, equals(20000000.0));
        // Total expense must ONLY be 2M (Food) + 3M (Shopping) = 5M (Transfer 5M must NOT be added!)
        expect(summary.totalExpense, equals(5000000.0));
        expect(summary.netSavings, equals(15000000.0)); // 20M - 5M = 15M
        expect(summary.savingsRate, equals(75.0)); // 15M / 20M * 100% = 75%

        // Top categories breakdown
        expect(summary.topCategories.length, equals(2));
        expect(summary.topCategories.first.categoryName, equals('Mua sắm'));
        expect(summary.topCategories.first.amount, equals(3000000.0));
        expect(
          summary.topCategories.first.percentage,
          equals(60.0),
        ); // 3M / 5M * 100% = 60%
      },
    );
  });
}
