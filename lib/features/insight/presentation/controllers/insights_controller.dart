import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../analytics/presentation/controllers/analytics_controller.dart';
import '../../../budget/presentation/controllers/budget_controller.dart';
import '../../../subscription/presentation/controllers/subscriptions_controller.dart';
import '../../../wallet/presentation/controllers/wallets_controller.dart';
import '../../domain/entities/insight_entity.dart';
import '../../domain/services/insight_engine_service.dart';

final insightEngineServiceProvider = Provider<InsightEngineService>((ref) {
  return const InsightEngineService();
});

final insightsProvider = Provider<List<InsightEntity>>((ref) {
  final engine = ref.watch(insightEngineServiceProvider);
  final thisMonthAnalytics = ref.watch(analyticsStreamProvider).valueOrNull;
  final budget = ref.watch(currentBudgetStreamProvider).valueOrNull;
  final subscriptions = ref.watch(subscriptionsStreamProvider).valueOrNull ?? [];
  final wallets = ref.watch(walletsStreamProvider).valueOrNull ?? [];

  return engine.evaluateAllRules(
    thisMonthAnalytics: thisMonthAnalytics,
    currentBudget: budget,
    subscriptions: subscriptions,
    wallets: wallets,
  );
});

final topInsightProvider = Provider<InsightEntity?>((ref) {
  final insights = ref.watch(insightsProvider);
  if (insights.isEmpty) return null;
  // Critical first, then Warning, then Positive, then Info
  final sorted = List<InsightEntity>.from(insights)
    ..sort((a, b) => b.severity.index.compareTo(a.severity.index));
  return sorted.first;
});
