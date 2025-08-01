import 'package:dio/dio.dart';

import '../../debug/app_logger.dart';
import '../response/models/models.dart';
import 'app_error_code.dart';
import 'error_code.dart';
export 'package:dartz/dartz.dart' hide Order;

class Failure implements Exception {
  final String message;
  final ErrorCode errorCode;
  final Map<String, dynamic> errorsMetadata;

  String get devCode => errorCode.value;

  const Failure({
    required this.errorCode,
    required this.message,
    this.errorsMetadata = const {},
  });

  StackTrace get stackTrace => StackTrace.current;

  bool isCode(ErrorCode failureCode) {
    return failureCode.value.trim().toLowerCase() ==
        errorCode.value.trim().toLowerCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'errorCode': devCode,
      'errorSource': errorCode.runtimeType.toString(),
      'errorMessage': message,
      'errorDetails': errorsMetadata,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Failure copyWith({
    ErrorCode? errorCode,
    String? message,
    Map<String, dynamic>? errorsMetadata,
  }) {
    return Failure(
      errorCode: errorCode ?? this.errorCode,
      message: message ?? this.message,
      errorsMetadata: errorsMetadata ?? this.errorsMetadata,
    );
  }

  static Failure from(Object? error) {
    appLogger.warning('Failure.from: $error');

    try {
      if (error is Failure) {
        return error;
      } else if (error is ErrorCode) {
        return error.toFailure();
      } else if (error is DioException) {
        if (error.error is NetworkFailure) {
          final networkFailure = error.error as NetworkFailure;
          return Failure(
            errorCode: networkFailure.errorCode,
            message: networkFailure.message,
            errorsMetadata: networkFailure.errorsMetadata,
          );
        }
      }
      return Failure(
        errorCode: AppErrorCode.UNEXPECTED_ERROR,
        message: error?.toString() ?? 'Unknown error',
      );
    } catch (e) {
      return Failure(
        errorCode: AppErrorCode.UNEXPECTED_ERROR,
        message: error?.toString() ?? 'Unknown error',
      );
    }
  }

  static Failure safeCast(error) {
    if (error is Failure) {
      return error;
    }
    return Failure.from(error);
  }
}

extension FailureDynamicX on dynamic {
  Failure toFailure() {
    return Failure.from(this);
  }
}
