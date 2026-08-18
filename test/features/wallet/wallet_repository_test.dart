import 'package:drift/native.dart';
import 'package:finly/core/database/app_database.dart';
import 'package:finly/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:finly/features/wallet/domain/entities/wallet_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late WalletRepositoryImpl repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = WalletRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('WalletRepositoryImpl Tests', () {
    test(
      'Create, read, and calculate total net worth from active wallets',
      () async {
        final newWallet = WalletEntity(
          id: 'wallet_momo',
          name: 'Ví MoMo',
          type: WalletType.ewallet,
          balance: 1000000.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final createResult = await repository.createWallet(newWallet);
        expect(createResult.isSuccess, isTrue);

        final allWalletsResult = await repository.getWallets();
        expect(allWalletsResult.isSuccess, isTrue);
        expect(
          allWalletsResult.dataOrNull!.length,
          equals(3),
        ); // 2 seeded + 1 new

        final netWorthResult = await repository.getTotalNetWorth();
        expect(netWorthResult.isSuccess, isTrue);
        // 2,500,000 + 15,800,000 + 1,000,000 = 19,300,000
        expect(netWorthResult.dataOrNull, equals(19300000.0));
      },
    );

    test('Delete (archive) wallet excludes it from active list', () async {
      final deleteResult = await repository.deleteWallet('wallet_default_cash');
      expect(deleteResult.isSuccess, isTrue);

      final activeWallets = await repository.getWallets();
      expect(
        activeWallets.dataOrNull!.any((w) => w.id == 'wallet_default_cash'),
        isFalse,
      );
    });
  });
}
