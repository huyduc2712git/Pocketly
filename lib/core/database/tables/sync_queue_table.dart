import 'package:drift/drift.dart';

@DataClassName('SyncQueueRow')
class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  TextColumn get id => text()();
  TextColumn get entityType =>
      text()(); // 'wallet', 'category', 'transaction', 'budget', etc.
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // 'create', 'update', 'delete'
  TextColumn get payload => text()(); // JSON string
  TextColumn get status => text().withDefault(
    const Constant('pending'),
  )(); // 'pending', 'syncing', 'synced', 'failed'
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
