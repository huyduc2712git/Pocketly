import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:finly/features/analytics/presentation/pages/analytics_page.dart';
import 'package:finly/features/auth/presentation/controllers/auth_controller.dart';
import 'package:finly/features/auth/presentation/pages/login_page.dart';
import 'package:finly/features/auth/presentation/pages/onboarding_page.dart';
import 'package:finly/features/auth/presentation/pages/profile_page.dart';
import 'package:finly/features/budget/presentation/pages/budget_page.dart';
import 'package:finly/features/dashboard/presentation/pages/home_page.dart';
import 'package:finly/features/transaction/presentation/pages/transactions_page.dart';
import 'package:finly/features/transaction/presentation/widgets/quick_add_transaction_sheet.dart';
import 'package:finly/features/wallet/presentation/pages/wallets_page.dart';
import 'package:finly/shared/widgets/app_shell.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.home,
    debugLogDiagnostics: false,
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isAuth = authState is Authenticated;
      final isLoggingIn = state.matchedLocation == RouteNames.login;
      final isOnboarding = state.matchedLocation == RouteNames.onboarding;

      if (!isAuth &&
          !isLoggingIn &&
          !isOnboarding &&
          authState is Unauthenticated) {
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
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Branch 2: Transactions
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.transactions,
                builder: (context, state) => const TransactionsPage(),
              ),
            ],
          ),
          // Branch 3: Budget
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.budget,
                builder: (context, state) => const BudgetPage(),
              ),
            ],
          ),
          // Branch 4: Analytics
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.analytics,
                builder: (context, state) => const AnalyticsPage(),
              ),
            ],
          ),
          // Branch 5: Profile
          StatefulShellBranch(
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

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authControllerProvider, (previous, next) => notifyListeners());
  }
}
