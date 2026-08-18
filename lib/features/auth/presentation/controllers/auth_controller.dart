import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Providers
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return const SecureStorageService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(storageService: storage);
});

// Auth State
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

// Controller Notifier
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = const AuthLoading();
    final isAuth = await _repository.isAuthenticated();
    if (!isAuth) {
      // Auto-authenticate as guest for seamless offline-first initial experience
      final guestResult = await _repository.loginAsGuest();
      guestResult.when(
        success: (user) => state = Authenticated(user),
        failure: (_) => state = const Unauthenticated(),
      );
      return;
    }

    final result = await _repository.getCurrentUser();
    result.when(
      success: (user) => state = Authenticated(user),
      failure: (_) => state = const Unauthenticated(),
    );
  }

  Future<bool> login(String email, String password) async {
    state = const AuthLoading();
    final result = await _repository.login(email: email, password: password);
    return result.when(
      success: (user) {
        state = Authenticated(user);
        return true;
      },
      failure: (failure) {
        state = AuthError(failure.message);
        return false;
      },
    );
  }

  Future<bool> loginAsGuest() async {
    state = const AuthLoading();
    final result = await _repository.loginAsGuest();
    return result.when(
      success: (user) {
        state = Authenticated(user);
        return true;
      },
      failure: (failure) {
        state = AuthError(failure.message);
        return false;
      },
    );
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await _repository.logout();
    state = const Unauthenticated();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthController(repository);
});
