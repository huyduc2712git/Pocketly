import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/budget/presentation/pages/budget_page.dart';
import '../../features/dashboard/presentation/pages/home_page.dart';
import '../../features/transaction/presentation/pages/transactions_page.dart';
import '../../features/transaction/presentation/widgets/quick_add_transaction_sheet.dart';
import '../../features/wallet/presentation/pages/wallets_page.dart';
import '../../shared/widgets/app_shell.dart';
import 'route_names.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final _shellNavigatorTransactions = GlobalKey<NavigatorState>(debugLabel: 'shellTransactions');
final _shellNavigatorBudget = GlobalKey<NavigatorState>(debugLabel: 'shellBudget');
final _shellNavigatorAnalytics = GlobalKey<NavigatorState>(debugLabel: 'shellAnalytics');
final _shellNavigatorProfile = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.home,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuth = authState is Authenticated;
      final isLoggingIn = state.matchedLocation == RouteNames.login;
      final isOnboarding = state.matchedLocation == RouteNames.onboarding;

      if (!isAuth && !isLoggingIn && !isOnboarding && authState is Unauthenticated) {
        return RouteNames.login;
      }
      if (isAuth && (isLoggingIn || isOnboarding)) {
        return RouteNames.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.wallets,
        builder: (context, state) => const WalletsPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(
            navigationShell: navigationShell,
            onQuickAction: (action) {
              QuickAddTransactionSheet.show(context, initialType: action);
            },
          );
        },
        branches: [
          // Branch 1: Home
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHome,
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Branch 2: Transactions
          StatefulShellBranch(
            navigatorKey: _shellNavigatorTransactions,
            routes: [
              GoRoute(
                path: RouteNames.transactions,
                builder: (context, state) => const TransactionsPage(),
              ),
            ],
          ),
          // Branch 3: Budget
          StatefulShellBranch(
            navigatorKey: _shellNavigatorBudget,
            routes: [
              GoRoute(
                path: RouteNames.budget,
                builder: (context, state) => const BudgetPage(),
              ),
            ],
          ),
          // Branch 4: Analytics
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAnalytics,
            routes: [
              GoRoute(
                path: RouteNames.analytics,
                builder: (context, state) => const AnalyticsPage(),
              ),
            ],
          ),
          // Branch 5: Profile
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfile,
            routes: [
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
