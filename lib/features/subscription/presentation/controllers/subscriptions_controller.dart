import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SubscriptionRepositoryImpl(db: db);
});

final subscriptionsStreamProvider = StreamProvider<List<SubscriptionEntity>>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return repo.watchSubscriptions();
});

final totalMonthlySubscriptionCostProvider = Provider<double>((ref) {
  final subsAsync = ref.watch(subscriptionsStreamProvider);
  return subsAsync.maybeWhen(
    data: (subs) => subs
        .where((s) => s.isActive)
        .fold(0.0, (sum, s) => sum + s.monthlyCost),
    orElse: () => 0.0,
  );
});

class SubscriptionsController extends StateNotifier<AsyncValue<void>> {
  final SubscriptionRepository _repository;

  SubscriptionsController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> createSubscription(SubscriptionEntity entity) async {
    state = const AsyncValue.loading();
    final result = await _repository.createSubscription(entity);
    return result.when(
      success: (_) {
        state = const AsyncValue.data(null);
        return true;
      },
      failure: (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
    );
  }

  Future<bool> toggleActive(SubscriptionEntity entity) async {
    final updated = entity.copyWith(isActive: !entity.isActive);
    final result = await _repository.updateSubscription(updated);
    return result.isSuccess;
  }

  Future<bool> deleteSubscription(String id) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteSubscription(id);
    return result.when(
      success: (_) {
        state = const AsyncValue.data(null);
        return true;
      },
      failure: (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
    );
  }
}

final subscriptionsControllerProvider =
    StateNotifierProvider<SubscriptionsController, AsyncValue<void>>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return SubscriptionsController(repo);
});
