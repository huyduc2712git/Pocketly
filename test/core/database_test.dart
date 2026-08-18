import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift AppDatabase tests', () {
    test('Database creates tables and seeds default categories and initial wallets', () async {
      final categories = await db.select(db.categoriesTable).get();
      expect(categories, isNotEmpty);
      expect(categories.any((c) => c.id == 'cat_food'), isTrue);
      expect(categories.any((c) => c.id == 'cat_salary'), isTrue);

      final wallets = await db.select(db.walletsTable).get();
      expect(wallets.length, equals(2));
      expect(wallets.any((w) => w.id == 'wallet_default_cash'), isTrue);
    });

    test('Insert and query a new transaction with wallet and category references', () async {
      final now = DateTime.now();
      const transactionId = 'test_tx_01';

      await db.into(db.transactionsTable).insert(
            TransactionsTableCompanion.insert(
              id: transactionId,
              type: 'expense',
              amount: 150000.0,
              currency: const Value('VND'),
              walletId: 'wallet_default_cash',
              categoryId: const Value('cat_food'),
              note: const Value('Bún chả trưa'),
              occurredAt: now,
              syncStatus: const Value('pending'),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      final tx = await (db.select(db.transactionsTable)..where((tbl) => tbl.id.equals(transactionId)))
          .getSingleOrNull();

      expect(tx, isNotNull);
      expect(tx!.amount, equals(150000.0));
      expect(tx.type, equals('expense'));
      expect(tx.note, equals('Bún chả trưa'));
      expect(tx.walletId, equals('wallet_default_cash'));
      expect(tx.categoryId, equals('cat_food'));
      expect(tx.syncStatus, equals('pending'));
    });

    test('Insert and query a sync queue task', () async {
      final now = DateTime.now();
      const syncId = 'sync_01';

      await db.into(db.syncQueueTable).insert(
            SyncQueueTableCompanion.insert(
              id: syncId,
              entityType: 'transaction',
              entityId: 'test_tx_01',
              operation: 'create',
              payload: '{"id": "test_tx_01", "amount": 150000}',
              status: const Value('pending'),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      final syncItem = await (db.select(db.syncQueueTable)..where((tbl) => tbl.id.equals(syncId)))
          .getSingleOrNull();

      expect(syncItem, isNotNull);
      expect(syncItem!.status, equals('pending'));
      expect(syncItem.entityType, equals('transaction'));
    });
  });
}
