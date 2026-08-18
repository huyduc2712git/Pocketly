sealed class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ (code?.hashCode ?? 0);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    super.message = 'Lỗi cơ sở dữ liệu cục bộ.',
    super.code = 'DATABASE_FAILURE',
  });
}

class NetworkFailure extends Failure {
  final int? statusCode;

  const NetworkFailure({
    super.message = 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra mạng.',
    super.code = 'NETWORK_FAILURE',
    this.statusCode,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_FAILURE',
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.',
    super.code = 'UNAUTHORIZED',
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Lỗi truy xuất bộ nhớ tạm.',
    super.code = 'CACHE_FAILURE',
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Đã có lỗi không mong muốn xảy ra.',
    super.code = 'UNEXPECTED_FAILURE',
  });
}
