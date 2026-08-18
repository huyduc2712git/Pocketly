import 'package:finly/core/result/result.dart';
import 'package:finly/features/auth/domain/entities/user_entity.dart';
import 'package:finly/features/auth/domain/repositories/auth_repository.dart';
import 'package:finly/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('AuthController tests', () {
    final testUser = UserEntity(
      id: 'test_user_01',
      email: 'test@finly.local',
      name: 'Test User',
      preferredCurrency: 'VND',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test(
      'Initial checkAuthStatus sets Authenticated when user is logged in',
      () async {
        when(
          () => mockRepository.isAuthenticated(),
        ).thenAnswer((_) async => true);
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Result.success(testUser));

        final controller = AuthController(mockRepository);
        await pumpEventQueue();

        expect(controller.state, isA<Authenticated>());
        final state = controller.state as Authenticated;
        expect(state.user.name, equals('Test User'));
      },
    );

    test('Login success updates state to Authenticated', () async {
      when(
        () => mockRepository.isAuthenticated(),
      ).thenAnswer((_) async => false);
      when(
        () => mockRepository.loginAsGuest(),
      ).thenAnswer((_) async => Result.success(testUser));
      when(
        () => mockRepository.login(
          email: 'alex@example.com',
          password: 'password123',
        ),
      ).thenAnswer((_) async => Result.success(testUser));

      final controller = AuthController(mockRepository);
      await pumpEventQueue();

      final result = await controller.login('alex@example.com', 'password123');
      expect(result, isTrue);
      expect(controller.state, isA<Authenticated>());
    });

    test(
      'Logout clears session and updates state to Unauthenticated',
      () async {
        when(
          () => mockRepository.isAuthenticated(),
        ).thenAnswer((_) async => true);
        when(
          () => mockRepository.getCurrentUser(),
        ).thenAnswer((_) async => Result.success(testUser));
        when(
          () => mockRepository.logout(),
        ).thenAnswer((_) async => const Result.success(null));

        final controller = AuthController(mockRepository);
        await pumpEventQueue();

        await controller.logout();
        expect(controller.state, isA<Unauthenticated>());
      },
    );
  });
}
