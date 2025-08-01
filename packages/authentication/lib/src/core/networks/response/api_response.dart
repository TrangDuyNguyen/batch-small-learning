import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../authentication_module.dart';

part 'api_response.g.dart';

/// Một version đc implement lại từ StandardErrorResponse của backend
/// để xử lý các trường hợp lỗi cụ thể
/// @Có thể implement một cách tùy biến cho từng project
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> extends StandardResponse<T> {
  final int? total;
  final Map<String, dynamic>? errorsMetadata;

  ApiResponse({
    super.data,
    int? status_code,
    String? message,
    super.status,
    this.total,
    this.errorsMetadata,
  }) : super(
         status_code: status_code ?? -1,
         message: message ?? status,
         errorCode: errorsMetadata?['error_code'] as String?,
         errorDetails: errorsMetadata?['error_details'] as String?,
       );

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}

ApiResponse<T> fromJson<T>(
  Map<String, dynamic> json,
  T Function(Object?) fromJsonT,
) => ApiResponse.fromJson(json, fromJsonT);

ApiResponse<T> fromResponse<T>(
  Response response,
  T Function(Object?) fromJsonT,
) {
  appLogger.monitor({
    'statusCode': response.statusCode,
    'error_code': response.data['error_code'],
    'message': response.data['message'],
    'data': response.data['data'],
    'status': response.data['status'],
    'total': response.data['total'],
  });

  return ApiResponse.fromJson({
    /// code của network
    'status_code': response.statusCode,

    /// message của network
    'message': response.data['message'],

    /// data của network
    'data': response.data['data'],

    /// status của network
    'status': response.data['status'],

    /// total của network
    'total': response.data['total'],

    /// errors của network
    'errors': {
      'error_code': response.data['error_code'],
      'error_details': response.data['error_details'],
    },
  }, fromJsonT);
}
