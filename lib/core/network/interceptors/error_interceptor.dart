import 'package:dio/dio.dart';
import '../../error/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapDioErrorToAppException(err);
    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
        message: appException.message,
      ),
    );
  }

  AppException _mapDioErrorToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Kết nối mạng quá hạn. Vui lòng thử lại sau.',
          code: 'TIMEOUT',
        );
      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'Không có kết nối Internet hoặc máy chủ không phản hồi.',
          code: 'NO_CONNECTION',
        );
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return const UnauthorizedException();
        }
        if (statusCode == 422 || statusCode == 400) {
          final data = err.response?.data;
          final msg = (data is Map && data['message'] != null)
              ? data['message'].toString()
              : 'Dữ liệu yêu cầu không hợp lệ.';
          return ValidationException(message: msg);
        }
        return NetworkException(
          message: 'Máy chủ phản hồi lỗi ($statusCode). Vui lòng thử lại.',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return const NetworkException(
          message: 'Yêu cầu mạng đã bị hủy.',
          code: 'REQUEST_CANCELLED',
        );
      default:
        return const UnexpectedException(
          message: 'Có lỗi mạng không xác định xảy ra.',
        );
    }
  }
}
