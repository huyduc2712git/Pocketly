import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:finly/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:finly/features/subscription/domain/entities/subscription_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late SubscriptionRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = SubscriptionRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('SubscriptionRepositoryImpl Tests', () {
    test('Create subscriptions and verify monthly equivalent cost calculations', () async {
      final now = DateTime.now();

      final netflix = SubscriptionEntity(
        id: 'sub_netflix',
        name: 'Netflix 4K',
        amount: 260000.0,
        walletId: 'wallet_bank_primary',
        billingCycle: SubscriptionBillingCycle.monthly,
        nextBillingDate: now.add(const Duration(days: 15)),
        createdAt: now,
        updatedAt: now,
      );

      final icloud = SubscriptionEntity(
        id: 'sub_icloud',
        name: 'iCloud 2TB',
        amount: 1200000.0,
        walletId: 'wallet_bank_primary',
        billingCycle: SubscriptionBillingCycle.yearly,
        nextBillingDate: now.add(const Duration(days: 200)),
        createdAt: now,
        updatedAt: now,
      );

      await repository.createSubscription(netflix);
      await repository.createSubscription(icloud);

      final listResult = await repository.getSubscriptions();
      expect(listResult.isSuccess, isTrue);
      expect(listResult.dataOrNull!.length, equals(2));

      // Monthly cost of Netflix = 260,000
      expect(netflix.monthlyCost, equals(260000.0));
      // Monthly equivalent cost of iCloud (1.2M yearly) = 100,000 / month
      expect(icloud.monthlyCost, equals(100000.0));
    });
  });
}
