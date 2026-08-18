import 'package:drift/drift.dart';
import 'users_table.dart';

@DataClassName('BudgetRow')
class BudgetsTable extends Table {
  @override
  String get tableName => 'budgets';

  TextColumn get id => text()();
  TextColumn get userId => text().nullable().references(
    UsersTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get month => integer()(); // 1 - 12
  IntColumn get year => integer()();
  RealColumn get totalAmount => real()();
  TextColumn get currency => text().withDefault(const Constant('VND'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
