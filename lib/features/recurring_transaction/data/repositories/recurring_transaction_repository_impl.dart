import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/entities/recurring_transaction_entity.dart';
import '../../domain/repositories/recurring_transaction_repository.dart';

class RecurringTransactionRepositoryImpl implements RecurringTransactionRepository {
  final AppDatabase db;

  RecurringTransactionRepositoryImpl({required this.db});

  @override
  Stream<List<RecurringTransactionEntity>> watchRecurringTransactions() {
    final query = _buildJoinedQuery();
    return query.watch().map((rows) => rows.map(_mapJoinedRow).toList());
  }

  @override
  Future<Result<List<RecurringTransactionEntity>>> getRecurringTransactions() async {
    try {
      final query = _buildJoinedQuery();
      final rows = await query.get();
      return Result.success(rows.map(_mapJoinedRow).toList());
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<RecurringTransactionEntity>> createRecurringTransaction(
      RecurringTransactionEntity entity) async {
    try {
      final now = DateTime.now();
      final id = entity.id.isNotEmpty ? entity.id : IdGenerator.generate();

      await db.transaction(() async {
        await db.into(db.recurringTransactionsTable).insert(
              RecurringTransactionsTableCompanion.insert(
                id: id,
                type: entity.type,
                amount: entity.amount,
                currency: Value(entity.currency),
                walletId: entity.walletId,
                toWalletId: Value(entity.toWalletId),
                categoryId: Value(entity.categoryId),
                note: Value(entity.note),
                frequency: entity.frequency.name,
                interval: Value(entity.interval),
                startDate: entity.startDate,
                endDate: Value(entity.endDate),
                nextExecutionDate: entity.nextExecutionDate,
                isActive: Value(entity.isActive),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        await db.into(db.syncQueueTable).insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'recurring_transaction',
                entityId: id,
                operation: 'create',
                payload: '{"id": "$id", "amount": ${entity.amount}}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });

      return Result.success(entity.copyWith(id: id, createdAt: now, updatedAt: now));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<RecurringTransactionEntity>> updateRecurringTransaction(
      RecurringTransactionEntity entity) async {
    try {
      final now = DateTime.now();

      await db.transaction(() async {
        await (db.update(db.recurringTransactionsTable)..where((tbl) => tbl.id.equals(entity.id))).write(
          RecurringTransactionsTableCompanion(
            type: Value(entity.type),
            amount: Value(entity.amount),
            currency: Value(entity.currency),
            walletId: Value(entity.walletId),
            toWalletId: Value(entity.toWalletId),
            categoryId: Value(entity.categoryId),
            note: Value(entity.note),
            frequency: Value(entity.frequency.name),
            interval: Value(entity.interval),
            startDate: Value(entity.startDate),
            endDate: Value(entity.endDate),
            nextExecutionDate: Value(entity.nextExecutionDate),
            isActive: Value(entity.isActive),
            updatedAt: Value(now),
          ),
        );

        await db.into(db.syncQueueTable).insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'recurring_transaction',
                entityId: entity.id,
                operation: 'update',
                payload: '{"id": "${entity.id}"}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });

      return Result.success(entity.copyWith(updatedAt: now));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> deleteRecurringTransaction(String id) async {
    try {
      final now = DateTime.now();
      await db.transaction(() async {
        await (db.delete(db.recurringTransactionsTable)..where((tbl) => tbl.id.equals(id))).go();
        await db.into(db.syncQueueTable).insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'recurring_transaction',
                entityId: id,
                operation: 'delete',
                payload: '{"id": "$id"}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  JoinedSelectStatement _buildJoinedQuery() {
    final sourceWallet = db.walletsTable.createAlias('sourceWallet');
    final destWallet = db.walletsTable.createAlias('destWallet');

    return db.select(db.recurringTransactionsTable).join([
      leftOuterJoin(sourceWallet, sourceWallet.id.equalsExp(db.recurringTransactionsTable.walletId)),
      leftOuterJoin(destWallet, destWallet.id.equalsExp(db.recurringTransactionsTable.toWalletId)),
      leftOuterJoin(db.categoriesTable, db.categoriesTable.id.equalsExp(db.recurringTransactionsTable.categoryId)),
    ])..orderBy([
        OrderingTerm.asc(db.recurringTransactionsTable.nextExecutionDate),
      ]);
  }

  RecurringTransactionEntity _mapJoinedRow(TypedResult row) {
    final rt = row.readTable(db.recurringTransactionsTable);
    final sourceWallet = row.readTableOrNull(db.walletsTable.createAlias('sourceWallet'));
    final destWallet = row.readTableOrNull(db.walletsTable.createAlias('destWallet'));
    final category = row.readTableOrNull(db.categoriesTable);

    return RecurringTransactionEntity(
      id: rt.id,
      type: rt.type,
      amount: rt.amount,
      currency: rt.currency,
      walletId: rt.walletId,
      walletName: sourceWallet?.name,
      toWalletId: rt.toWalletId,
      toWalletName: destWallet?.name,
      categoryId: rt.categoryId,
      categoryName: category?.name,
      categoryIcon: category?.icon,
      categoryColor: category?.color,
      note: rt.note,
      frequency: RecurringFrequency.fromString(rt.frequency),
      interval: rt.interval,
      startDate: rt.startDate,
      endDate: rt.endDate,
      nextExecutionDate: rt.nextExecutionDate,
      isActive: rt.isActive,
      createdAt: rt.createdAt,
      updatedAt: rt.updatedAt,
    );
  }
}
