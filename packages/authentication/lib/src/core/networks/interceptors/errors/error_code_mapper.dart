import 'package:dio/dio.dart';

import '../../../debug/app_logger.dart';
import '../../errors/app_error_code.dart';
import '../../errors/error_mapper.dart';
import '../../response/models/models.dart';

extension DioExceptionExtension on DioException {
  NetworkFailure toNetworkFailure() {
    // Extract and convert to NetworkFailure
    if (error is NetworkFailure) return error as NetworkFailure;
    // Determine failure type based on DioExceptionType
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure.timeout(message);
      case DioExceptionType.connectionError:
        return NetworkFailure.connection(message);
      case DioExceptionType.badResponse:
        appLogger.error('Bad response==== ${response?.statusCode}');
        if (response?.data is Map) {
          final data = response?.data as Map<String, dynamic>;
          final errorCode = data['errorCode'];
          final appErrorCode = AppErrorCode.fromNumericCode(
            errorCode.toString(),
          );
          if (errorCode != null && appErrorCode != null) {
            return NetworkFailure.api(
              code: appErrorCode,
              message: data['message'] as String?,
              extras: {'response': response?.data},
            );
          }
        }
        return NetworkFailure.network(
          statusCode: response?.statusCode ?? 0,
          message: message ?? 'Bad response',
          extras: {'response': response?.data},
        );
      case DioExceptionType.cancel:
        return NetworkFailure.fromFailure(
          AppErrorCode.CANCEL.toFailure(message: message),
        );
      default:
        return NetworkFailure.network(
          statusCode: response?.statusCode ?? 0,
          message: message ?? 'Network error',
          extras: {'response': response?.data},
        );
    }
  }
}

/// Interceptor for parsing error codes from API responses and standardizing errors
class ErrorParseInterceptor extends QueuedInterceptor {
  ErrorParseInterceptor(this._errorMapper);
  final INetworkFailureMapper _errorMapper;

  /// Parse response and create NetworkFailure if error code in response exists
  /// If error code is not found, create next interceptor
  /// Network is success if statusCode is in [NetworkStatusCode.successStatus]
  /// Api is error if errorCode is not null
  @override
  void onResponse(response, handler) {
    try {
      final parsedResponse = _errorMapper.parseResponse(response);

      if (parsedResponse == null) {
        handler.next(response);
        return;
      }

      if (!parsedResponse.isApiError()) {
        handler.next(response);
        return;
      }

      final err = DioException.badResponse(
        statusCode: response.statusCode ?? -1,
        requestOptions: response.requestOptions,
        response: response,
      );

      final networkFailure = err.toNetworkFailure();

      handler.reject(
        err.copyWith(error: networkFailure, message: networkFailure.message),
      );
    } catch (e) {
      // Error handling with NetworkFailure
      appLogger.error('lỗi khi xử lý response $e');

      rethrow;
    }
  }

  /// Convert DioException to NetworkFailure and enhance error
  /// If error is NetworkFailure, return it
  /// If error is not NetworkFailure, create new DioException with NetworkFailure as payload
  @override
  void onError(DioException err, handler) {
    try {
      // Convert to NetworkFailure
      final networkFailure = err.toNetworkFailure();

      // Create new DioException with NetworkFailure as payload
      handler.reject(
        err.copyWith(error: networkFailure, message: networkFailure.message),
      );
    } catch (e, stackTrace) {
      appLogger.error(
        'Error handling failure',
        error: e,
        stackTrace: stackTrace,
      );
      handler.reject(err);
    }
  }
}
