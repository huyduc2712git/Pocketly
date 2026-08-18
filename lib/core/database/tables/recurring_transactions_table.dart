import 'package:drift/drift.dart';
import 'categories_table.dart';
import 'wallets_table.dart';

@DataClassName('RecurringTransactionRow')
class RecurringTransactionsTable extends Table {
  @override
  String get tableName => 'recurring_transactions';

  TextColumn get id => text()();
  TextColumn get type => text()(); // 'expense', 'income', 'transfer'
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('VND'))();
  
  @ReferenceName('walletRecurringTransactions')
  TextColumn get walletId => text().references(WalletsTable, #id, onDelete: KeyAction.cascade)();
  
  @ReferenceName('toWalletRecurringTransactions')
  TextColumn get toWalletId => text().nullable().references(WalletsTable, #id, onDelete: KeyAction.setNull)();
  
  TextColumn get categoryId => text().nullable().references(CategoriesTable, #id, onDelete: KeyAction.setNull)();
  TextColumn get note => text().nullable()();
  TextColumn get frequency => text()(); // 'daily', 'weekly', 'monthly', 'yearly'
  IntColumn get interval => integer().withDefault(const Constant(1))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get nextExecutionDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
