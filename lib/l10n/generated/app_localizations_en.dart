// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Pocketly';

  @override
  String get appTagline => 'Smart Financial Management';

  @override
  String get navHome => 'Dashboard';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navBudget => 'Budget';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navProfile => 'Profile';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonSuccess => 'Success';

  @override
  String get commonError => 'An error occurred';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonEmpty => 'No data available';

  @override
  String get commonRetry => 'Retry';

  @override
  String get dashboardTotalBalance => 'Total Available Balance';

  @override
  String get dashboardIncome => 'Income';

  @override
  String get dashboardExpense => 'Expense';

  @override
  String get dashboardRemainingBudget => 'Remaining Budget';

  @override
  String get dashboardBudgetProgress => 'Budget Progress';

  @override
  String get dashboardSmartInsight => 'Finly Smart Insight';

  @override
  String get dashboardCategoryBudgets => 'Category Budgets';

  @override
  String get dashboardRecentTransactions => 'Recent Transactions';

  @override
  String get transactionAdd => 'Add Transaction';

  @override
  String get transactionAddExpense => 'Expense';

  @override
  String get transactionAddIncome => 'Income';

  @override
  String get transactionAddTransfer => 'Transfer';

  @override
  String get transactionAmount => 'Amount';

  @override
  String get transactionCategory => 'Category';

  @override
  String get transactionWallet => 'Wallet';

  @override
  String get transactionSourceWallet => 'Source Wallet (From)';

  @override
  String get transactionDestWallet => 'Destination Wallet (To)';

  @override
  String get transactionNote => 'Note';

  @override
  String get transactionDate => 'Date';

  @override
  String get transactionDeleted => 'Transaction deleted successfully';

  @override
  String get budgetTitle => 'Spending Budget';

  @override
  String get budgetMonthlyLimit => 'Monthly Limit';

  @override
  String get budgetSetMonthly => 'Set Budget';

  @override
  String budgetForecastWarning(String amount) {
    return 'Projected month-end budget overflow by $amount';
  }

  @override
  String get analyticsTitle => 'Analytics & Reports';

  @override
  String get analyticsSpendingBreakdown => 'Spending Breakdown';

  @override
  String get analyticsCashflowTrend => 'Cashflow Trend';

  @override
  String get analyticsSavingsRate => 'Savings Rate';

  @override
  String get analyticsNetSavings => 'Net Savings';

  @override
  String get subscriptionTitle => 'Subscriptions & Recurring';

  @override
  String get subscriptionMonthlyBurden => 'Monthly Subscription Cost';

  @override
  String subscriptionDaysRemaining(int days) {
    return '$days days left';
  }

  @override
  String get profileTitle => 'Profile & Settings';

  @override
  String get profileSyncStatus => 'Data Sync';

  @override
  String get profileSyncNow => 'Sync Now';

  @override
  String get profileExportCsv => 'Export to CSV';

  @override
  String get profileExportJson => 'Export to JSON';

  @override
  String get profileDarkMode => 'Dark Mode';

  @override
  String get profileCurrency => 'Primary Currency';

  @override
  String get profileLogout => 'Log Out';
}
