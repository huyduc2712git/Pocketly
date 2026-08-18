import 'dart:developer' as developer;

class AppLogger {
  AppLogger._();

  static bool isEnabled = true;

  static void debug(
    String message, {
    String tag = 'DEBUG',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!isEnabled) return;
    developer.log(
      '🔍 $message',
      name: tag,
      error: error,
      stackTrace: stackTrace,
      level: 500,
    );
  }

  static void info(String message, {String tag = 'INFO'}) {
    if (!isEnabled) return;
    developer.log('ℹ️ $message', name: tag, level: 800);
  }

  static void warning(String message, {String tag = 'WARN', Object? error}) {
    if (!isEnabled) return;
    developer.log('⚠️ $message', name: tag, error: error, level: 900);
  }

  static void error(
    String message, {
    String tag = 'ERROR',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      '🚨 $message',
      name: tag,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}
