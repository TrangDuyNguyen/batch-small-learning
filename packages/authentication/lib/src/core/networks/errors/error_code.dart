// failure_code.dart

import 'errors_module.dart';

abstract class ErrorCode {
  String get value;
  String get defaultMessage;
  const ErrorCode();

  Failure toFailure({
    String? message,
    String? errorCode,
    Map<String, dynamic>? extras,
  }) {
    return Failure(
      errorCode: this,
      message: message ?? defaultMessage,
      errorsMetadata: extras ?? {},
    );
  }
}
