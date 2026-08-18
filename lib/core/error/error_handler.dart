import 'app_exception.dart';
import 'failures.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handleException(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) {
      return _mapAppExceptionToFailure(error);
    }
    return UnexpectedFailure(message: error.toString());
  }

  static Failure _mapAppExceptionToFailure(AppException exception) {
    return switch (exception) {
      final NetworkException e => NetworkFailure(
        message: e.message,
        code: e.code,
        statusCode: e.statusCode,
      ),
      final DatabaseException e => DatabaseFailure(
        message: e.message,
        code: e.code,
      ),
      final ValidationException e => ValidationFailure(
        message: e.message,
        code: e.code,
      ),
      final UnauthorizedException e => UnauthorizedFailure(
        message: e.message,
        code: e.code,
      ),
      final CacheException e => CacheFailure(message: e.message, code: e.code),
      final UnexpectedException e => UnexpectedFailure(
        message: e.message,
        code: e.code,
      ),
    };
  }
}
