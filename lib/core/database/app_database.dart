import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../constants/db_constants.dart';
import 'tables/budget_items_table.dart';
import 'tables/budgets_table.dart';
import 'tables/categories_table.dart';
import 'tables/insights_table.dart';
import 'tables/recurring_transactions_table.dart';
import 'tables/subscriptions_table.dart';
import 'tables/sync_queue_table.dart';
import 'tables/transactions_table.dart';
import 'tables/users_table.dart';
import 'tables/wallets_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UsersTable,
    WalletsTable,
    CategoriesTable,
    TransactionsTable,
    BudgetsTable,
    BudgetItemsTable,
    RecurringTransactionsTable,
    SubscriptionsTable,
    InsightsTable,
    SyncQueueTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => DbConstants.databaseVersion;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: DbConstants.databaseName,
      native: const DriftNativeOptions(shareAcrossIsolates: true),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedDefaultCategories();
        await _seedInitialWallet();
      },
      beforeOpen: (details) async {
        // Enable foreign keys in SQLite
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _seedDefaultCategories() async {
    final now = DateTime.now();
    final defaultCategories = [
      CategoriesTableCompanion.insert(
        id: 'cat_food',
        name: 'Ăn uống',
        type: 'expense',
        icon: 'fastfood_rounded',
        color: '0xFFFF7043',
        isSystem: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_transport',
        name: 'Di chuyển',
        type: 'expense',
        icon: 'directions_car_rounded',
        color: '0xFF42A5F5',
        isSystem: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_bills',
        name: 'Hóa đơn & Tiện ích',
        type: 'expense',
        icon: 'receipt_long_rounded',
        color: '0xFFAB47BC',
        isSystem: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_shopping',
        name: 'Mua sắm',
        type: 'expense',
        icon: 'shopping_bag_rounded',
        color: '0xFFEC407A',
        isSystem: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_entertainment',
        name: 'Giải trí',
        type: 'expense',
        icon: 'sports_esports_rounded',
        color: '0xFF26A69A',
        isSystem: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_salary',
        name: 'Lương & Thưởng',
        type: 'income',
        icon: 'payments_rounded',
        color: '0xFF66BB6A',
        isSystem: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_investment',
        name: 'Đầu tư & Sinh lời',
        type: 'income',
        icon: 'trending_up_rounded',
        color: '0xFF29B6F6',
        isSystem: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_other_income',
        name: 'Thu nhập khác',
        type: 'income',
        icon: 'account_balance_wallet_rounded',
        color: '0xFF78909C',
        isSystem: const Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    ];

    await batch((batch) {
      batch.insertAll(categoriesTable, defaultCategories);
    });
  }

  Future<void> _seedInitialWallet() async {
    final now = DateTime.now();
    await into(walletsTable).insert(
      WalletsTableCompanion.insert(
        id: 'wallet_default_cash',
        name: 'Tiền mặt',
        type: 'cash',
        balance: const Value(2500000.0),
        currency: const Value('VND'),
        icon: const Value('wallet_rounded'),
        color: const Value('0xFF10B981'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    await into(walletsTable).insert(
      WalletsTableCompanion.insert(
        id: 'wallet_bank_primary',
        name: 'Tài khoản Ngân hàng',
        type: 'bank',
        balance: const Value(15800000.0),
        currency: const Value('VND'),
        icon: const Value('account_balance_rounded'),
        color: const Value('0xFF3B82F6'),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }
}
