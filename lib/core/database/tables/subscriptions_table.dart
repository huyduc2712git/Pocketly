import 'package:drift/drift.dart';
import 'categories_table.dart';
import 'wallets_table.dart';

@DataClassName('SubscriptionRow')
class SubscriptionsTable extends Table {
  @override
  String get tableName => 'subscriptions';

  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('VND'))();
  TextColumn get icon => text().nullable()();
  TextColumn get walletId =>
      text().references(WalletsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get categoryId => text().nullable().references(
    CategoriesTable,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get billingCycle => text().withDefault(
    const Constant('monthly'),
  )(); // 'weekly', 'monthly', 'yearly'
  DateTimeColumn get nextBillingDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get remindDaysBefore => integer().withDefault(const Constant(2))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
