import '../../../../core/result/result.dart';
import '../entities/subscription_entity.dart';

abstract class SubscriptionRepository {
  Stream<List<SubscriptionEntity>> watchSubscriptions();
  Future<Result<List<SubscriptionEntity>>> getSubscriptions();
  Future<Result<SubscriptionEntity>> createSubscription(
    SubscriptionEntity subscription,
  );
  Future<Result<SubscriptionEntity>> updateSubscription(
    SubscriptionEntity subscription,
  );
  Future<Result<void>> deleteSubscription(String id);
}
