import 'package:authentication/src/core/networks/refresh/refresh_module.dart';
import 'package:dio/dio.dart';

import '../../../../authentication_module.dart';

/// The PublicTokenInterceptor class is an implementation of the Dio [Interceptor]
/// that handles adding authorization headers for public API requests.
/// This interceptor is simpler than TokenInterceptor as public tokens don't need
/// refresh mechanism.
class PublicTokenInterceptor extends Interceptor {
  /// Creates a [PublicTokenInterceptor] with the given [tokenManager]
  /// and optional [authTemplate].
  PublicTokenInterceptor({
    required this.tokenManager,
    this.authTemplate = const {'Authorization': 'Bearer '},
  });

  /// The PublicTokenManager instance used to manage public tokens
  final PublicTokenManager tokenManager;

  /// Template for authorization headers
  final Map<String, String> authTemplate;

  /// Gets the authorization headers using the provided public token
  Map<String, String> getAuthorizationHeaders(String publicToken) {
    return authTemplate.map((key, value) => MapEntry(key, value + publicToken));
  }

  /// Intercepts outgoing requests to add the authorization headers for public APIs.
  ///
  /// Retrieves the public token from the [tokenManager] and adds it to the
  /// request headers. Unlike TokenInterceptor, this doesn't handle token refresh
  /// as public tokens don't expire.
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final publicToken = Session.targetAccessToken;
      if (options.headers['Authorization'] == null) {
        final headers = getAuthorizationHeaders(publicToken);
        options.headers.addAll(headers);
      }

      return handler.next(options);
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: TokenManagerException(
            TokenErrorMessages.failedToGetPublicToken,
          ),
        ),
      );
    }
  }

  /// Handle errors from public API requests
  ///
  /// This is simpler than TokenInterceptor's error handling as we don't need
  /// to handle token refresh scenarios
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if error is due to invalid public token
    if (err.response?.statusCode == 401) {
      await tokenManager.clearPublicToken();
    }

    return handler.next(err);
  }
}
