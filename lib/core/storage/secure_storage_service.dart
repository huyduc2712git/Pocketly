import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class StorageService {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
  Future<void> deleteAll();
}

class SecureStorageService implements StorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyIsFirstTime = 'is_first_time';

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await write(key: keyAccessToken, value: accessToken);
    await write(key: keyRefreshToken, value: refreshToken);
  }

  Future<String?> getAccessToken() => read(key: keyAccessToken);
  Future<String?> getRefreshToken() => read(key: keyRefreshToken);

  Future<void> clearAuthTokens() async {
    await delete(key: keyAccessToken);
    await delete(key: keyRefreshToken);
  }
}
