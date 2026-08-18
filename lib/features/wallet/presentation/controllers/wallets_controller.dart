import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return WalletRepositoryImpl(db: db);
});

final walletsStreamProvider = StreamProvider<List<WalletEntity>>((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  return repository.watchWallets();
});

final totalNetWorthProvider = Provider<double>((ref) {
  final walletsAsync = ref.watch(walletsStreamProvider);
  return walletsAsync.maybeWhen(
    data: (wallets) => wallets
        .where((w) => !w.isArchived && !w.isExcludedFromTotal)
        .fold(0.0, (sum, w) => sum + w.balance),
    orElse: () => 0.0,
  );
});

class WalletsController extends StateNotifier<AsyncValue<void>> {
  final WalletRepository _repository;

  WalletsController(this._repository) : super(const AsyncValue.data(null));

  Future<bool> createWallet({
    required String name,
    required WalletType type,
    required double initialBalance,
    String? icon,
    String? color,
    bool isExcludedFromTotal = false,
  }) async {
    state = const AsyncValue.loading();
    final newWallet = WalletEntity(
      id: '',
      name: name,
      type: type,
      balance: initialBalance,
      icon: icon ?? _getDefaultIcon(type),
      color: color ?? _getDefaultColor(type),
      isExcludedFromTotal: isExcludedFromTotal,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _repository.createWallet(newWallet);
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

  Future<bool> deleteWallet(String id) async {
    state = const AsyncValue.loading();
    final result = await _repository.deleteWallet(id);
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

  String _getDefaultIcon(WalletType type) {
    switch (type) {
      case WalletType.cash:
        return 'wallet_rounded';
      case WalletType.bank:
        return 'account_balance_rounded';
      case WalletType.ewallet:
        return 'phone_android_rounded';
      case WalletType.credit:
        return 'credit_card_rounded';
      case WalletType.savings:
        return 'savings_rounded';
    }
  }

  String _getDefaultColor(WalletType type) {
    switch (type) {
      case WalletType.cash:
        return '0xFF10B981';
      case WalletType.bank:
        return '0xFF3B82F6';
      case WalletType.ewallet:
        return '0xFFEC4899';
      case WalletType.credit:
        return '0xFFF59E0B';
      case WalletType.savings:
        return '0xFF8B5CF6';
    }
  }
}

final walletsControllerProvider =
    StateNotifierProvider<WalletsController, AsyncValue<void>>((ref) {
  final repository = ref.watch(walletRepositoryProvider);
  return WalletsController(repository);
});
