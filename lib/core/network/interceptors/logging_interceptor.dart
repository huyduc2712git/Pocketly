import 'package:dio/dio.dart';
import '../../logger/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug(
      '🌐 HTTP ${options.method} --> ${options.uri}',
      tag: 'DIO',
    );
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      '✅ HTTP ${response.statusCode} <-- ${response.requestOptions.uri}',
      tag: 'DIO',
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '❌ HTTP Error [${err.response?.statusCode}] on ${err.requestOptions.uri}: ${err.message}',
      tag: 'DIO',
      error: err,
    );
    return handler.next(err);
  }
}
