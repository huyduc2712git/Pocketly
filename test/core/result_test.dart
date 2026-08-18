import 'package:finly/core/error/failures.dart';
import 'package:finly/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result<T> functional pattern tests', () {
    test('Result.success should store data and evaluate isSuccess to true', () {
      const result = Result.success('finly_test_data');

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, equals('finly_test_data'));
      expect(result.failureOrNull, isNull);

      final folded = result.fold(
        (failure) => 'error',
        (data) => 'success: $data',
      );
      expect(folded, equals('success: finly_test_data'));
    });

    test(
      'Result.failure should store failure and evaluate isFailure to true',
      () {
        const failure = NetworkFailure(message: 'Network connection failed');
        const result = Result<String>.failure(failure);

        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.dataOrNull, isNull);
        expect(result.failureOrNull, equals(failure));

        final folded = result.fold(
          (failure) => 'error: ${failure.message}',
          (data) => 'success: $data',
        );
        expect(folded, equals('error: Network connection failed'));
      },
    );

    test('Result.map should transform success value and propagate failure', () {
      const successResult = Result.success(100);
      final mappedSuccess = successResult.map((val) => val * 2);
      expect(mappedSuccess.dataOrNull, equals(200));

      const failureResult = Result<int>.failure(DatabaseFailure());
      final mappedFailure = failureResult.map((val) => val * 2);
      expect(mappedFailure.isFailure, isTrue);
      expect(mappedFailure.failureOrNull, isA<DatabaseFailure>());
    });
  });
}
