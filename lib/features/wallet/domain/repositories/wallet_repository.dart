import '../../../../core/result/result.dart';
import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  Stream<List<WalletEntity>> watchWallets();
  Future<Result<List<WalletEntity>>> getWallets();
  Future<Result<WalletEntity>> getWalletById(String id);
  Future<Result<WalletEntity>> createWallet(WalletEntity wallet);
  Future<Result<WalletEntity>> updateWallet(WalletEntity wallet);
  Future<Result<void>> deleteWallet(String id);
  Future<Result<double>> getTotalNetWorth();
}
