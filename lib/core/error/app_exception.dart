sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({required this.message, this.code, this.details});

  @override
  String toString() =>
      '$runtimeType(message: $message, code: $code, details: $details)';
}

class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });
}

class DatabaseException extends AppException {
  const DatabaseException({required super.message, super.code, super.details});
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.details,
  });
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Phiên đăng nhập đã hết hạn hoặc không hợp lệ.',
    super.code = 'UNAUTHORIZED',
    super.details,
  });
}

class CacheException extends AppException {
  const CacheException({required super.message, super.code, super.details});
}

class UnexpectedException extends AppException {
  const UnexpectedException({
    super.message = 'Đã có lỗi không xác định xảy ra.',
    super.code = 'UNEXPECTED_ERROR',
    super.details,
  });
}
