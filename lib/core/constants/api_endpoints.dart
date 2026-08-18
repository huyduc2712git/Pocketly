class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.finly.app/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/me';

  // Wallets
  static const String wallets = '/wallets';
  static String walletDetail(String id) => '/wallets/$id';

  // Categories
  static const String categories = '/categories';

  // Transactions
  static const String transactions = '/transactions';
  static String transactionDetail(String id) => '/transactions/$id';

  // Budgets
  static const String budgets = '/budgets';
  static String budgetDetail(String id) => '/budgets/$id';

  // Analytics & Insights
  static const String analyticsSummary = '/analytics/summary';
  static const String insights = '/insights';

  // Sync
  static const String sync = '/sync';
}
