import 'package:authentication/src/core/networks/refresh/refresh_module.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:dio/dio.dart';

import '../../../../authentication_module.dart';
import '../../config/app_config.dart';

final _dioClient =
    RestAPI(
      baseUrl: AppConfig.getBaseUrl,
      restConfig: DefaultRestAPIConfig(
        headerProcessorIter: UserAgentHeaderInterceptor(
          BasicHeaderInterceptor(),
        ),
        isRetryEnabled: true,
        retryConfig: RetryConfig.standard(),
      ),
    ).dio;

/// The TokenInterceptor class is an implementation of the Dio [Interceptor]
/// that handles adding authorization headers to requests and refreshing tokens
/// when necessary.
class TokenInterceptor extends QueuedInterceptor {
  /// Creates a [TokenInterceptor] with the given [tokenManager] and
  /// [tokenRefreshStrategy].
  TokenInterceptor({
    required this.tokenManager,
    required this.tokenRefreshStrategy,
  });

  // Add cancel token
  CancelToken? _refreshCancelToken;
  final Map<String, CancelToken> _requestTokens = {};

  /// The TokenManager instance used to manage access and refresh tokens.
  final TokenManager tokenManager;

  /// The TokenRefreshStrategy instance used to define the strategy for
  /// refreshing tokens.
  final TokenRefreshStrategy tokenRefreshStrategy;

  /// Intercepts outgoing requests to add the authorization headers.
  ///
  /// Retrieves the access token from the [tokenManager] and uses the
  /// [tokenRefreshStrategy] to get the authorization headers. Adds these
  /// headers to the request options.
  ///
  /// If an error occurs while retrieving the access token, rejects the request
  /// with a [TokenManagerException].
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Add cancel token for request
      final cancelToken = CancelToken();
      _requestTokens[options.path] = cancelToken;
      options.cancelToken = cancelToken;

      final accessToken = Session.targetAccessToken;
      appLogger.debug('TokenInterceptor: $accessToken');
      if (options.headers['Authorization'] == null) {
        final headers = tokenRefreshStrategy.getAuthorizationHeaders(
          accessToken,
        );
        options.headers.addAll(headers);
      }
      return handler.next(options);
    } catch (e) {
      // Clean up cancel token if request fails
      _requestTokens.remove(options.path);
      return handler.reject(
        DioException(
          requestOptions: options,
          error: TokenManagerException(
            TokenErrorMessages.failedToGetAccessToken,
          ),
        ),
      );
    }
  }

  /// Intercepts errors to handle token refresh if necessary.
  ///
  /// If the error indicates that the token should be refreshed, uses the
  /// [tokenRefreshStrategy] to refresh the token. If successful, retries the
  /// original request with the new token. If the refresh fails, clears the
  /// tokens using the [tokenManager] and rejects the request with a
  /// [TokenRefreshException].
  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // Clean up cancel token for failed request
    _requestTokens.remove(err.requestOptions.path);

    if (err.response != null &&
        tokenRefreshStrategy.shouldRefreshToken(err.response!)) {
      try {
        // Create new cancel token for refresh
        _refreshCancelToken = CancelToken();

        final mNewAccessToken = await tokenRefreshStrategy.refreshToken(
          _dioClient,
          tokenManager,
        );

        if (mNewAccessToken != null) {
          // Create new cancel token for retry request
          final retryCancelToken = CancelToken();
          _requestTokens[err.requestOptions.path] = retryCancelToken;

          final cloneReq = await tokenRefreshStrategy
              .getAuthorizationHeaders(mNewAccessToken)
              .let((headers) async {
                err.requestOptions.headers.addAll(headers);
                return await _dioClient.request(
                  err.requestOptions.path,
                  options: Options(
                    method: err.requestOptions.method,
                    headers: err.requestOptions.headers,
                  ),
                  cancelToken: retryCancelToken, // Add cancel token
                );
              });

          if (cloneReq.statusCode == 200) {
            await tokenManager.saveAccessToken(mNewAccessToken);
            return handler.resolve(cloneReq);
          } else {
            throw TokenRefreshException(
              TokenErrorMessages.failedToRefreshAccessToken,
            );
          }
        } else {
          return handler.next(err);
        }
      } catch (e) {
        return _handleFailureRefresh(err, handler);
      } finally {
        _refreshCancelToken = null;
      }
    }
    return handler.next(err);
  }

  Future _handleFailureRefresh(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    /// If the token refresh fails, clear the tokens and reject the request.
    await tokenManager.clearTokens();
    cancelAllRequests('Token refresh failed');
    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: TokenRefreshException(
          TokenErrorMessages.failedToRefreshAccessToken,
        ),
      ),
    );
  }

  // Add method to cancel all requests
  void cancelAllRequests([String? reason]) {
    _refreshCancelToken?.cancel(reason);
    _requestTokens.forEach((_, token) => token.cancel(reason));
    _requestTokens.clear();
  }

  void dispose() {
    cancelAllRequests('Interceptor disposed');
    _refreshCancelToken = null;
    _requestTokens.clear();
  }
}
