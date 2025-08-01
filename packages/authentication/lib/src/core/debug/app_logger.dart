import 'dart:convert';

import 'package:logger/logger.dart';

final appLogger = AppLogger();

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  Logger? _logger;

  factory AppLogger() => _instance;

  Logger _getLogger({bool hasStackTrace = false}) {
    return Logger(
      printer: PrettyPrinter(
        methodCount: hasStackTrace ? 1 : 0,
        excludePaths: ['package:core/src/debug/app_logger.dart'],
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: false,
      ),
    );
  }

  AppLogger._internal();

  void log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger = _getLogger(hasStackTrace: stackTrace != null);
    final effectiveTag = tag ?? _getClassNameFromStackTrace();
    final logMessage = _formatLogMessage(level, message, effectiveTag);

    switch (level) {
      case LogLevel.debug:
        _logger?.d(
          logMessage,
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case LogLevel.info:
        _logger?.i(
          logMessage,
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case LogLevel.warning:
        _logger?.w(
          logMessage,
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case LogLevel.fatal:
        _logger?.f(
          logMessage,
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case LogLevel.trace:
        _logger?.t(
          logMessage,
          error: error,
          stackTrace: stackTrace,
        );
        break;
      case LogLevel.error:
        _logger?.e(
          logMessage,
          error: error,
          stackTrace: stackTrace,
        );
    }
  }

  String? _getClassNameFromStackTrace() {
    try {
      final frames = StackTrace.current.toString().split('\n');

      /// print function name and line number
      if (frames.length >= 3) {
        final frame = frames[3].trim();
        final className = frame
            .split(' ')
            .firstWhere(
              (element) => element.contains('.'),
            )
            .split('.')[0];
        final functionName = frame
            .split(' ')
            .firstWhere(
              (element) => element.contains('.'),
            )
            .split('.')[1];
        final lineNumber = frame.split(' ').last;
        return '$className:$functionName:$lineNumber';
      }
    } catch (e) {
      appLogger.error('Error getting class name from stack trace: $e');
      return null;
    }
    return null;
  }

  String _formatLogMessage(
    LogLevel level,
    String message,
    String? tag,
  ) {
    final displayTag = tag ?? 'unknown';
    return '[$displayTag] => $message';
  }

  // Convenience methods
  void debug(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.debug,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  void info(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.info,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  void warning(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.warning,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.error,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  void fatal(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.fatal,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  void trace(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.trace,
        message,
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  void monitor(
    Map<String, dynamic> message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      log(
        LogLevel.debug,
        jsonEncode(message),
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );

  void monitorQuotes(
    String message, {
    String? tag,
    String? quotes,
    LogLevel level = LogLevel.debug,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      log(
        level,
        '$message "$quotes"',
        tag: tag,
        error: error,
        stackTrace: stackTrace,
      );
}

/// Các cấp độ log
enum LogLevel {
  /// Thông tin chi tiết nhất, thường dùng để debug
  trace(0, 'TRACE'),

  /// Thông tin debug thông thường
  debug(1, 'DEBUG'),

  /// Thông tin chung về hoạt động của ứng dụng
  info(2, 'INFO'),

  /// Cảnh báo, có thể tiếp tục thực thi nhưng cần chú ý
  warning(3, 'WARNING'),

  /// Lỗi xảy ra nhưng không làm dừng ứng dụng
  error(4, 'ERROR'),

  /// Lỗi nghiêm trọng, thường dẫn đến ứng dụng dừng hoạt động
  fatal(5, 'FATAL');

  final int value;
  final String name;

  const LogLevel(this.value, this.name);

  /// Kiểm tra level hiện tại có lớn hơn hoặc bằng level được kiểm tra không
  bool shouldLog(LogLevel levelToCheck) => value <= levelToCheck.value;
}
