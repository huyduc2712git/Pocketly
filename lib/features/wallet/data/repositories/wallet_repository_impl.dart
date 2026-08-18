import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final AppDatabase db;

  WalletRepositoryImpl({required this.db});

  WalletEntity _toEntity(WalletRow row) {
    return WalletEntity(
      id: row.id,
      userId: row.userId,
      name: row.name,
      type: WalletType.fromString(row.type),
      balance: row.balance,
      currency: row.currency,
      icon: row.icon,
      color: row.color,
      isArchived: row.isArchived,
      isExcludedFromTotal: row.isExcludedFromTotal,
      syncStatus: row.syncStatus,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  @override
  Stream<List<WalletEntity>> watchWallets() {
    return (db.select(db.walletsTable)
          ..where((tbl) => tbl.isArchived.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  @override
  Future<Result<List<WalletEntity>>> getWallets() async {
    try {
      final rows =
          await (db.select(db.walletsTable)
                ..where((tbl) => tbl.isArchived.equals(false))
                ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
              .get();
      return Result.success(rows.map(_toEntity).toList());
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<WalletEntity>> getWalletById(String id) async {
    try {
      final row = await (db.select(
        db.walletsTable,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (row == null) {
        return const Result.failure(
          DatabaseFailure(message: 'Không tìm thấy ví tiền'),
        );
      }
      return Result.success(_toEntity(row));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<WalletEntity>> createWallet(WalletEntity wallet) async {
    try {
      final now = DateTime.now();
      final id = wallet.id.isNotEmpty ? wallet.id : IdGenerator.generate();
      final companion = WalletsTableCompanion.insert(
        id: id,
        userId: Value(wallet.userId),
        name: wallet.name,
        type: wallet.type.name,
        balance: Value(wallet.balance),
        currency: Value(wallet.currency),
        icon: Value(wallet.icon),
        color: Value(wallet.color),
        isArchived: Value(wallet.isArchived),
        isExcludedFromTotal: Value(wallet.isExcludedFromTotal),
        syncStatus: const Value('pending'),
        createdAt: Value(now),
        updatedAt: Value(now),
      );

      await db.transaction(() async {
        await db.into(db.walletsTable).insert(companion);
        await db
            .into(db.syncQueueTable)
            .insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'wallet',
                entityId: id,
                operation: 'create',
                payload:
                    '{"id": "$id", "name": "${wallet.name}", "balance": ${wallet.balance}}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });

      return Result.success(
        wallet.copyWith(id: id, createdAt: now, updatedAt: now),
      );
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<WalletEntity>> updateWallet(WalletEntity wallet) async {
    try {
      final now = DateTime.now();
      await db.transaction(() async {
        await (db.update(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals(wallet.id))).write(
          WalletsTableCompanion(
            name: Value(wallet.name),
            type: Value(wallet.type.name),
            currency: Value(wallet.currency),
            icon: Value(wallet.icon),
            color: Value(wallet.color),
            isArchived: Value(wallet.isArchived),
            isExcludedFromTotal: Value(wallet.isExcludedFromTotal),
            updatedAt: Value(now),
          ),
        );

        await db
            .into(db.syncQueueTable)
            .insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'wallet',
                entityId: wallet.id,
                operation: 'update',
                payload: '{"id": "${wallet.id}", "name": "${wallet.name}"}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });

      return Result.success(wallet.copyWith(updatedAt: now));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> deleteWallet(String id) async {
    try {
      final now = DateTime.now();
      await db.transaction(() async {
        await (db.update(
          db.walletsTable,
        )..where((tbl) => tbl.id.equals(id))).write(
          WalletsTableCompanion(
            isArchived: const Value(true),
            updatedAt: Value(now),
          ),
        );

        await db
            .into(db.syncQueueTable)
            .insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'wallet',
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

  @override
  Future<Result<double>> getTotalNetWorth() async {
    try {
      final wallets =
          await (db.select(db.walletsTable)..where(
                (tbl) =>
                    tbl.isArchived.equals(false) &
                    tbl.isExcludedFromTotal.equals(false),
              ))
              .get();
      final total = wallets.fold<double>(0.0, (sum, w) => sum + w.balance);
      return Result.success(total);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }
}
