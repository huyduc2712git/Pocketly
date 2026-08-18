import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_filter.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase db;

  TransactionRepositoryImpl({required this.db});

  @override
  Stream<List<TransactionEntity>> watchTransactions({
    TransactionFilter? filter,
  }) {
    final query = _buildJoinedQuery(filter);
    return query.watch().map(
      (rows) => rows.map(_mapJoinedRowToEntity).toList(),
    );
  }

  @override
  Future<Result<List<TransactionEntity>>> getTransactions({
    TransactionFilter? filter,
  }) async {
    try {
      final query = _buildJoinedQuery(filter);
      final rows = await query.get();
      return Result.success(rows.map(_mapJoinedRowToEntity).toList());
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<TransactionEntity>> getTransactionById(String id) async {
    try {
      final query = _buildJoinedQuery(null)
        ..where(db.transactionsTable.id.equals(id));
      final rows = await query.get();
      if (rows.isEmpty) {
        return const Result.failure(
          DatabaseFailure(message: 'Không tìm thấy giao dịch'),
        );
      }
      return Result.success(_mapJoinedRowToEntity(rows.first));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<TransactionEntity>> addTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final now = DateTime.now();
      final id = transaction.id.isNotEmpty
          ? transaction.id
          : IdGenerator.generate();

      await db.transaction(() async {
        // 1. Update wallet balance(s)
        await _applyBalanceImpact(
          type: transaction.type,
          amount: transaction.amount,
          walletId: transaction.walletId,
          toWalletId: transaction.toWalletId,
        );

        // 2. Insert transaction
        await db
            .into(db.transactionsTable)
            .insert(
              TransactionsTableCompanion.insert(
                id: id,
                type: transaction.type,
                amount: transaction.amount,
                currency: Value(transaction.currency),
                walletId: transaction.walletId,
                toWalletId: Value(transaction.toWalletId),
                categoryId: Value(transaction.categoryId),
                note: Value(transaction.note),
                occurredAt: transaction.occurredAt,
                metadata: Value(transaction.metadata),
                syncStatus: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        // 3. Queue for sync
        await db
            .into(db.syncQueueTable)
            .insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'transaction',
                entityId: id,
                operation: 'create',
                payload:
                    '{"id": "$id", "amount": ${transaction.amount}, "type": "${transaction.type}"}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });

      return Result.success(
        transaction.copyWith(id: id, createdAt: now, updatedAt: now),
      );
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<TransactionEntity>> updateTransaction({
    required TransactionEntity oldTransaction,
    required TransactionEntity newTransaction,
  }) async {
    try {
      final now = DateTime.now();

      await db.transaction(() async {
        // 1. Reverse old impact
        await _reverseBalanceImpact(
          type: oldTransaction.type,
          amount: oldTransaction.amount,
          walletId: oldTransaction.walletId,
          toWalletId: oldTransaction.toWalletId,
        );

        // 2. Apply new impact
        await _applyBalanceImpact(
          type: newTransaction.type,
          amount: newTransaction.amount,
          walletId: newTransaction.walletId,
          toWalletId: newTransaction.toWalletId,
        );

        // 3. Update transaction row
        await (db.update(
          db.transactionsTable,
        )..where((tbl) => tbl.id.equals(newTransaction.id))).write(
          TransactionsTableCompanion(
            type: Value(newTransaction.type),
            amount: Value(newTransaction.amount),
            currency: Value(newTransaction.currency),
            walletId: Value(newTransaction.walletId),
            toWalletId: Value(newTransaction.toWalletId),
            categoryId: Value(newTransaction.categoryId),
            note: Value(newTransaction.note),
            occurredAt: Value(newTransaction.occurredAt),
            metadata: Value(newTransaction.metadata),
            syncStatus: const Value('pending'),
            updatedAt: Value(now),
          ),
        );

        // 4. Queue for sync
        await db
            .into(db.syncQueueTable)
            .insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'transaction',
                entityId: newTransaction.id,
                operation: 'update',
                payload:
                    '{"id": "${newTransaction.id}", "amount": ${newTransaction.amount}}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });

      return Result.success(newTransaction.copyWith(updatedAt: now));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> deleteTransaction(TransactionEntity transaction) async {
    try {
      final now = DateTime.now();

      await db.transaction(() async {
        // 1. Reverse old impact
        await _reverseBalanceImpact(
          type: transaction.type,
          amount: transaction.amount,
          walletId: transaction.walletId,
          toWalletId: transaction.toWalletId,
        );

        // 2. Delete transaction row
        await (db.delete(
          db.transactionsTable,
        )..where((tbl) => tbl.id.equals(transaction.id))).go();

        // 3. Queue for sync
        await db
            .into(db.syncQueueTable)
            .insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'transaction',
                entityId: transaction.id,
                operation: 'delete',
                payload: '{"id": "${transaction.id}"}',
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

  // --- Balance Calculation Helpers ---

  Future<void> _applyBalanceImpact({
    required String type,
    required double amount,
    required String walletId,
    String? toWalletId,
  }) async {
    final now = DateTime.now();
    if (type == 'expense') {
      final wallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).getSingle();
      await (db.update(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).write(
        WalletsTableCompanion(
          balance: Value(wallet.balance - amount),
          updatedAt: Value(now),
        ),
      );
    } else if (type == 'income') {
      final wallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).getSingle();
      await (db.update(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).write(
        WalletsTableCompanion(
          balance: Value(wallet.balance + amount),
          updatedAt: Value(now),
        ),
      );
    } else if (type == 'transfer') {
      final source = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).getSingle();
      await (db.update(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).write(
        WalletsTableCompanion(
          balance: Value(source.balance - amount),
          updatedAt: Value(now),
        ),
      );
      if (toWalletId != null && toWalletId.isNotEmpty) {
        final dest = await (db.select(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals(toWalletId))).getSingle();
        await (db.update(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals(toWalletId))).write(
          WalletsTableCompanion(
            balance: Value(dest.balance + amount),
            updatedAt: Value(now),
          ),
        );
      }
    }
  }

  Future<void> _reverseBalanceImpact({
    required String type,
    required double amount,
    required String walletId,
    String? toWalletId,
  }) async {
    final now = DateTime.now();
    if (type == 'expense') {
      final wallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).getSingle();
      await (db.update(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).write(
        WalletsTableCompanion(
          balance: Value(wallet.balance + amount),
          updatedAt: Value(now),
        ),
      );
    } else if (type == 'income') {
      final wallet = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).getSingle();
      await (db.update(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).write(
        WalletsTableCompanion(
          balance: Value(wallet.balance - amount),
          updatedAt: Value(now),
        ),
      );
    } else if (type == 'transfer') {
      final source = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).getSingle();
      await (db.update(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(walletId))).write(
        WalletsTableCompanion(
          balance: Value(source.balance + amount),
          updatedAt: Value(now),
        ),
      );
      if (toWalletId != null && toWalletId.isNotEmpty) {
        final dest = await (db.select(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals(toWalletId))).getSingle();
        await (db.update(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals(toWalletId))).write(
          WalletsTableCompanion(
            balance: Value(dest.balance - amount),
            updatedAt: Value(now),
          ),
        );
      }
    }
  }

  // --- Joined Queries & Mapping ---

  JoinedSelectStatement _buildJoinedQuery(TransactionFilter? filter) {
    final sourceWallet = db.walletsTable.createAlias('sourceWallet');
    final destWallet = db.walletsTable.createAlias('destWallet');

    final query = db.select(db.transactionsTable).join([
      leftOuterJoin(
        sourceWallet,
        sourceWallet.id.equalsExp(db.transactionsTable.walletId),
      ),
      leftOuterJoin(
        destWallet,
        destWallet.id.equalsExp(db.transactionsTable.toWalletId),
      ),
      leftOuterJoin(
        db.categoriesTable,
        db.categoriesTable.id.equalsExp(db.transactionsTable.categoryId),
      ),
    ]);

    if (filter != null) {
      if (filter.walletId != null) {
        query.where(
          db.transactionsTable.walletId.equals(filter.walletId!) |
              db.transactionsTable.toWalletId.equals(filter.walletId!),
        );
      }
      if (filter.categoryId != null) {
        query.where(db.transactionsTable.categoryId.equals(filter.categoryId!));
      }
      if (filter.type != null) {
        query.where(db.transactionsTable.type.equals(filter.type!));
      }
      if (filter.startDate != null) {
        query.where(
          db.transactionsTable.occurredAt.isBiggerOrEqualValue(
            filter.startDate!,
          ),
        );
      }
      if (filter.endDate != null) {
        query.where(
          db.transactionsTable.occurredAt.isSmallerOrEqualValue(
            filter.endDate!,
          ),
        );
      }
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        final term = '%${filter.searchQuery}%';
        query.where(
          db.transactionsTable.note.like(term) |
              db.categoriesTable.name.like(term),
        );
      }
    }

    query.orderBy([
      OrderingTerm.desc(db.transactionsTable.occurredAt),
      OrderingTerm.desc(db.transactionsTable.createdAt),
    ]);

    return query;
  }

  TransactionEntity _mapJoinedRowToEntity(TypedResult row) {
    final tx = row.readTable(db.transactionsTable);
    final sourceWallet = row.readTableOrNull(
      db.walletsTable.createAlias('sourceWallet'),
    );
    final destWallet = row.readTableOrNull(
      db.walletsTable.createAlias('destWallet'),
    );
    final category = row.readTableOrNull(db.categoriesTable);

    return TransactionEntity(
      id: tx.id,
      type: tx.type,
      amount: tx.amount,
      currency: tx.currency,
      walletId: tx.walletId,
      walletName: sourceWallet?.name,
      toWalletId: tx.toWalletId,
      toWalletName: destWallet?.name,
      categoryId: tx.categoryId,
      categoryName: category?.name,
      categoryIcon: category?.icon,
      categoryColor: category?.color,
      note: tx.note,
      occurredAt: tx.occurredAt,
      metadata: tx.metadata,
      syncStatus: tx.syncStatus,
      createdAt: tx.createdAt,
      updatedAt: tx.updatedAt,
    );
  }
}
