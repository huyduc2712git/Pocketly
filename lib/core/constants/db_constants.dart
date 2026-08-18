class DbConstants {
  DbConstants._();

  static const String databaseName = 'finly_database.sqlite';
  static const int databaseVersion = 1;

  // Table Names
  static const String usersTable = 'users';
  static const String walletsTable = 'wallets';
  static const String categoriesTable = 'categories';
  static const String transactionsTable = 'transactions';
  static const String budgetsTable = 'budgets';
  static const String budgetItemsTable = 'budget_items';
  static const String recurringTransactionsTable = 'recurring_transactions';
  static const String subscriptionsTable = 'subscriptions';
  static const String insightsTable = 'insights';
  static const String syncQueueTable = 'sync_queue';
}
