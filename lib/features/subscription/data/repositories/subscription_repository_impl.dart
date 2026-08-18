import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/result/result.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final AppDatabase db;

  SubscriptionRepositoryImpl({required this.db});

  @override
  Stream<List<SubscriptionEntity>> watchSubscriptions() {
    final query = _buildJoinedQuery();
    return query.watch().map((rows) => rows.map(_mapJoinedRow).toList());
  }

  @override
  Future<Result<List<SubscriptionEntity>>> getSubscriptions() async {
    try {
      final query = _buildJoinedQuery();
      final rows = await query.get();
      return Result.success(rows.map(_mapJoinedRow).toList());
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<SubscriptionEntity>> createSubscription(SubscriptionEntity subscription) async {
    try {
      final now = DateTime.now();
      final id = subscription.id.isNotEmpty ? subscription.id : IdGenerator.generate();

      await db.transaction(() async {
        await db.into(db.subscriptionsTable).insert(
              SubscriptionsTableCompanion.insert(
                id: id,
                name: subscription.name,
                amount: subscription.amount,
                currency: Value(subscription.currency),
                icon: Value(subscription.icon),
                walletId: subscription.walletId,
                categoryId: Value(subscription.categoryId),
                billingCycle: Value(subscription.billingCycle.name),
                nextBillingDate: subscription.nextBillingDate,
                isActive: Value(subscription.isActive),
                remindDaysBefore: Value(subscription.remindDaysBefore),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );

        await db.into(db.syncQueueTable).insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'subscription',
                entityId: id,
                operation: 'create',
                payload: '{"id": "$id", "name": "${subscription.name}", "amount": ${subscription.amount}}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });

      return Result.success(subscription.copyWith(id: id, createdAt: now, updatedAt: now));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<SubscriptionEntity>> updateSubscription(SubscriptionEntity subscription) async {
    try {
      final now = DateTime.now();

      await db.transaction(() async {
        await (db.update(db.subscriptionsTable)..where((tbl) => tbl.id.equals(subscription.id))).write(
          SubscriptionsTableCompanion(
            name: Value(subscription.name),
            amount: Value(subscription.amount),
            currency: Value(subscription.currency),
            icon: Value(subscription.icon),
            walletId: Value(subscription.walletId),
            categoryId: Value(subscription.categoryId),
            billingCycle: Value(subscription.billingCycle.name),
            nextBillingDate: Value(subscription.nextBillingDate),
            isActive: Value(subscription.isActive),
            remindDaysBefore: Value(subscription.remindDaysBefore),
            updatedAt: Value(now),
          ),
        );

        await db.into(db.syncQueueTable).insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'subscription',
                entityId: subscription.id,
                operation: 'update',
                payload: '{"id": "${subscription.id}"}',
                status: const Value('pending'),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      });

      return Result.success(subscription.copyWith(updatedAt: now));
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> deleteSubscription(String id) async {
    try {
      final now = DateTime.now();
      await db.transaction(() async {
        await (db.delete(db.subscriptionsTable)..where((tbl) => tbl.id.equals(id))).go();
        await db.into(db.syncQueueTable).insert(
              SyncQueueTableCompanion.insert(
                id: IdGenerator.generate(),
                entityType: 'subscription',
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
    return db.select(db.subscriptionsTable).join([
      innerJoin(db.walletsTable, db.walletsTable.id.equalsExp(db.subscriptionsTable.walletId)),
      leftOuterJoin(db.categoriesTable, db.categoriesTable.id.equalsExp(db.subscriptionsTable.categoryId)),
    ])..orderBy([
        OrderingTerm.asc(db.subscriptionsTable.nextBillingDate),
      ]);
  }

  SubscriptionEntity _mapJoinedRow(TypedResult row) {
    final sub = row.readTable(db.subscriptionsTable);
    final wallet = row.readTable(db.walletsTable);
    final category = row.readTableOrNull(db.categoriesTable);

    return SubscriptionEntity(
      id: sub.id,
      name: sub.name,
      amount: sub.amount,
      currency: sub.currency,
      icon: sub.icon,
      walletId: sub.walletId,
      walletName: wallet.name,
      categoryId: sub.categoryId,
      categoryName: category?.name,
      categoryColor: category?.color,
      billingCycle: SubscriptionBillingCycle.fromString(sub.billingCycle),
      nextBillingDate: sub.nextBillingDate,
      isActive: sub.isActive,
      remindDaysBefore: sub.remindDaysBefore,
      createdAt: sub.createdAt,
      updatedAt: sub.updatedAt,
    );
  }
}
