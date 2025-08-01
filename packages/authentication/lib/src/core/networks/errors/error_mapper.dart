import 'package:dio/dio.dart';

import '../response/models/base_reponse.dart';
import 'app_error_code.dart';
import 'error_code.dart';

/// Interface for error code mapping - provides methods to parse and transform API errors
abstract class INetworkFailureMapper {
  /// Maps a string error code to an internal ErrorCode
  ErrorCode? mapErrorCode(String? code);

  /// Parses a response to extract error information
  StandardResponse? parseResponse(Response? response);

  /// Extracts additional error details from a response
  Map<String, dynamic> extractErrorDetails(Response? response) => {};
}

/// Default implementation of error code mapping
class AppErrorCodeMapper implements INetworkFailureMapper {
  const AppErrorCodeMapper();

  /// Maps API error codes to app-specific error codes
  /// Defaults to UNEXPECTED_ERROR if code is null or unmappable
  @override
  ErrorCode? mapErrorCode(String? code) {
    if (code == null || code.isEmpty) {
      return AppErrorCode.PARSE_ERROR;
    }
    return AppErrorCode.fromCode(code) ?? AppErrorCode.PARSE_ERROR;
  }

  /// Base implementation returns null - subclasses should override
  @override
  StandardResponse? parseResponse(Response? response) {
    return null;
  }

  /// Extract error details from the response data
  @override
  Map<String, dynamic> extractErrorDetails(Response? response) {
    if (response?.data is Map) {
      try {
        return (response?.data as Map).cast<String, dynamic>();
      } catch (_) {
        // Gracefully handle casting errors
      }
    }
    return {};
  }
}
