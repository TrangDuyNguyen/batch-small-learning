import 'package:json_annotation/json_annotation.dart';

import '../../../debug/app_logger.dart';
import '../../errors/errors_module.dart';

part 'base_reponse.g.dart';

abstract class NetworkStatusCode {
  static List<int> successStatus = List.generate(100, (index) => index + 200);
  static List<int> authStatus = List.generate(100, (index) => index + 400);
  static List<int> serverStatus = List.generate(100, (index) => index + 500);
}

@JsonSerializable(genericArgumentFactories: true)
class StandardResponse<T> {
  StandardResponse({
    this.status_code,
    this.message,
    this.data,
    this.errorCode,
    this.errorDetails,
    this.status,
  });

  /// Đây là code network của backend
  final int? status_code;

  /// Đây là status của backend
  /// success, error
  final String? status;

  /// Đây là message của backend
  final String? message;

  /// Đây là code lỗi của backend
  final String? errorCode;

  /// Đây là chi tiết lỗi của backend
  final String? errorDetails;

  /// Đây là dữ liệu của backend
  final T? data;

  factory StandardResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$StandardResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T?) toJsonT) =>
      _$StandardResponseToJson(this, toJsonT);

  /// Đây là phương thức kiểm tra xem response có thành công hay không
  bool isNetworkSuccess() {
    return NetworkStatusCode.successStatus.contains(status_code);
  }

  bool isAuthError() {
    return NetworkStatusCode.authStatus.contains(status_code);
  }

  bool isApiError() {
    return errorCode != null;
  }

  /// Lấy dữ liệu hoặc throw lỗi
  T getOrThrow() {
    appLogger.monitor({
      'status_code': status_code,
      'isNetworkSuccess': NetworkStatusCode.successStatus.contains(status_code),
      'error_code': errorCode,
      'message': message,
      'status': status,
      'data': data,
    });

    if (isNetworkSuccess() && data != null) {
      appLogger.info('Network success');
      return data!;
    } else if (isAuthError()) {
      appLogger.error('Auth error');
      throw AppErrorCode.UNAUTHORIZED.toFailure(message: message);
    }
    throw failure;
  }

  T? getOrNull() {
    if (isNetworkSuccess() && data != null) {
      appLogger.info('Network success');
      return data!;
    }
    return null;
  }

  Failure get failure {
    final failureCode = errorCode?.toUpperCase();
    appLogger.error('Failure code==== $failureCode');
    if (failureCode == null) {
      return Failure(
        errorCode: AppErrorCode.UNEXPECTED_ERROR,
        message: "Không tìm thấy code lỗi",
        errorsMetadata: {
          'error_code': errorCode,
          'error_details': errorDetails,
        },
      );
    }
    final mappedError = AppErrorCode.fromCode(failureCode);
    appLogger.error('Mapped error==== $mappedError');
    return Failure(
      errorCode: mappedError ?? AppErrorCode.UNEXPECTED_ERROR,
      message: message ?? 'Có lỗi xảy ra trong quá trình xử lý',
      errorsMetadata: {'error_code': errorCode, 'error_details': errorDetails},
    );
  }
}
