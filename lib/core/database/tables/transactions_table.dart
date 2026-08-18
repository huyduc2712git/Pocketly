import 'package:drift/drift.dart';
import 'categories_table.dart';
import 'wallets_table.dart';

@DataClassName('TransactionRow')
class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  TextColumn get id => text()();
  TextColumn get type => text()(); // 'expense', 'income', 'transfer'
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('VND'))();
  
  @ReferenceName('walletTransactions')
  TextColumn get walletId => text().references(WalletsTable, #id, onDelete: KeyAction.cascade)();
  
  @ReferenceName('toWalletTransactions')
  TextColumn get toWalletId => text().nullable().references(WalletsTable, #id, onDelete: KeyAction.setNull)();
  
  TextColumn get categoryId => text().nullable().references(CategoriesTable, #id, onDelete: KeyAction.setNull)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get metadata => text().nullable()(); // JSON string
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))(); // 'pending', 'syncing', 'synced', 'failed'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
