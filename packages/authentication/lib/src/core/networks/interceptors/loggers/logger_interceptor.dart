import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../debug/app_logger.dart';

class JsonLoggerInterceptor extends Interceptor {
  @override
  void onRequest(options, handler) {
    logPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    logPrint('REQUEST[${options.method}] => HEADERS: ${options.headers}');

    final data = options.data;

    if (data is FormData) {
      logPrint('REQUEST[${options.method}] => DATA:');
      for (final entry in data.fields) {
        logPrint('• ${entry.key}: ${entry.value}');
      }
      for (final file in data.files) {
        logPrint(
            '• file field: ${file.key}, filename: ${file.value.filename}');
      }
    } else {
      try {
        logPrint('REQUEST[${options.method}] => DATA: ${jsonEncode(data)}');
      } catch (e) {
        logPrint(
            'REQUEST[${options.method}] => DATA: [non-encodable type: ${data.runtimeType}]');
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(response, handler) {
    appLogger.monitor({
      'status_code': response.statusCode,
      'data': response.data,
      'error_code': response.data['error_code'],
      'message': response.data['message'],
      'error_details': response.data['error_details'],
      'total': response.data['total'],
      'extras': response.data['extras'],
    });
    logPrint(
        'RESPONSE[${response.statusCode}] => DATA: ${jsonEncode(response.data)}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logPrint('ERROR[${err.response?.statusCode}] => MESSAGE: ${err.message}');
    super.onError(err, handler);
  }

  Future<void> logPrint(Object? object) async {
    debugPrint(object.toString());
  }
}
