import 'package:drift/drift.dart';

@DataClassName('InsightRow')
class InsightsTable extends Table {
  @override
  String get tableName => 'insights';

  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  TextColumn get severity => text().withDefault(
    const Constant('info'),
  )(); // 'info', 'warning', 'critical', 'positive'
  TextColumn get metadata => text().nullable()(); // JSON string
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
