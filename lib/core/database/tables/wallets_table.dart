import 'package:drift/drift.dart';
import 'users_table.dart';

@DataClassName('WalletRow')
class WalletsTable extends Table {
  @override
  String get tableName => 'wallets';

  TextColumn get id => text()();
  TextColumn get userId => text().nullable().references(UsersTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // 'cash', 'bank', 'ewallet', 'credit', 'savings'
  RealColumn get balance => real().withDefault(const Constant(0.0))();
  TextColumn get currency => text().withDefault(const Constant('VND'))();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isExcludedFromTotal => boolean().withDefault(const Constant(false))();
  TextColumn get syncStatus => text().withDefault(const Constant('synced'))(); // 'pending', 'syncing', 'synced', 'failed'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
