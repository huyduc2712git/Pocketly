import 'package:drift/drift.dart';
import 'budgets_table.dart';
import 'categories_table.dart';

@DataClassName('BudgetItemRow')
class BudgetItemsTable extends Table {
  @override
  String get tableName => 'budget_items';

  TextColumn get id => text()();
  TextColumn get budgetId =>
      text().references(BudgetsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get categoryId =>
      text().references(CategoriesTable, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
