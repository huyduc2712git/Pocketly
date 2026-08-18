import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SecureStorageService storageService;

  UserEntity? _cachedUser;

  AuthRepositoryImpl({required this.storageService});

  @override
  Future<bool> isAuthenticated() async {
    final token = await storageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final token = await storageService.getAccessToken();
      if (token == null) {
        return const Result.failure(UnauthorizedFailure());
      }

      _cachedUser ??= UserEntity(
        id: 'user_local_primary',
        email: 'alex.finly@example.com',
        name: 'Alex Nguyễn',
        preferredCurrency: 'VND',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      return Result.success(_cachedUser!);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return const Result.failure(ValidationFailure(message: 'Vui lòng nhập đầy đủ thông tin'));
      }

      await storageService.saveAuthTokens(
        accessToken: 'mock_jwt_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_jwt_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      final user = UserEntity(
        id: 'user_logged_in',
        email: email,
        name: email.split('@').first,
        preferredCurrency: 'VND',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _cachedUser = user;

      return Result.success(user);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<UserEntity>> loginAsGuest() async {
    try {
      await storageService.saveAuthTokens(
        accessToken: 'guest_access_token',
        refreshToken: 'guest_refresh_token',
      );

      final user = UserEntity(
        id: 'guest_user',
        email: 'guest@finly.local',
        name: 'Khách Finly',
        preferredCurrency: 'VND',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _cachedUser = user;

      return Result.success(user);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return const Result.failure(ValidationFailure(message: 'Vui lòng nhập đầy đủ thông tin'));
      }

      await storageService.saveAuthTokens(
        accessToken: 'mock_registered_access_token',
        refreshToken: 'mock_registered_refresh_token',
      );

      final user = UserEntity(
        id: 'user_registered',
        email: email,
        name: name,
        preferredCurrency: 'VND',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _cachedUser = user;

      return Result.success(user);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await storageService.clearAuthTokens();
      _cachedUser = null;
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ErrorHandler.handleException(e));
    }
  }
}
