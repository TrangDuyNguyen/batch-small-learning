import 'package:authentication/src/core/networks/refresh/refresh_module.dart';
import 'package:authentication/src/core/networks/response/api_response+.dart';
import 'package:dio/dio.dart';

import '../../../../authentication_module.dart';
import '../../../data/datasource/datasource_module.dart';
import '../response/api_response.dart';

/// A function type for handling token refresh.
///
/// Takes a [Dio] instance and a refresh token [String] as parameters, and
/// returns a [Future] that resolves to a [Response].
typedef TokenRefreshHandler =
    Future<Response> Function(Dio dio, String refreshToken);

typedef PublicTokenRefreshHandler = Future<Response> Function(Dio dio);

/// A function type for extracting a token from a [Response].
///
/// Takes a [Response] as a parameter and returns the token as a [String?].
typedef TokenExtractor = String? Function(Response response);

/// The TokenRefreshStrategy interface defines the contract for handling the
/// token refresh process. It includes methods for refreshing the token,
/// determining if a token should be refreshed, and getting authorization headers.
abstract class TokenRefreshStrategy {
  /// Refreshes the token using the provided [Dio] instance and [TokenManager].
  ///
  /// Returns the new access token as a [String], or null if the refresh fails.
  Future<String?> refreshToken(Dio dio, TokenManager tokenManager);

  /// Determines if the token should be refreshed based on the given [Response].
  ///
  /// Returns true if the token should be refreshed, false otherwise.
  bool shouldRefreshToken(Response response);

  /// Gets the authorization headers using the provided access token.
  ///
  /// Returns a map of headers.
  Map<String, String> getAuthorizationHeaders(String accessToken);
}

/// The TokenRefreshStrategyImpl class provides a concrete implementation of the
/// [TokenRefreshStrategy] interface, defining the strategy for refreshing tokens.
/// A function type for extracting various token information from a response.
class TokenResponseData {
  const TokenResponseData({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.expiresAt,
  });

  final String? accessToken;
  final String? refreshToken;
  final String? expiresIn;
  final String? expiresAt;

  // Add copyWith method for immutability
  TokenResponseData copyWith({
    String? accessToken,
    String? refreshToken,
    String? expiresIn,
    String? expiresAt,
  }) {
    return TokenResponseData(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

// Update the typedef to use the new model
typedef TokenResponseExtractor = TokenResponseData Function(Response response);

class TokenRefreshStrategyImpl implements TokenRefreshStrategy {
  TokenRefreshStrategyImpl({
    required this.refreshHandler,
    required this.tokenExtractor,
    this.successCodes = const [200],
    this.refreshCodes = const [401],
    this.authTemplate = const {'Authorization': 'Bearer '},
    this.retries = 1,
  });

  final TokenRefreshHandler refreshHandler;
  final TokenResponseExtractor tokenExtractor;
  final List<int> successCodes;
  final List<int> refreshCodes;
  final Map<String, String> authTemplate;
  final int retries;

  @override
  Future<String?> refreshToken(Dio dio, TokenManager tokenManager) async {
    final refreshToken = await _getValidRefreshToken(tokenManager);
    final response = await refreshHandler(dio, refreshToken);

    await _validateApiResponse(response);
    final tokens = _extractAndValidateTokens(response);
    await _updateTokenSession(tokenManager, tokens);

    return tokens.accessToken;
  }

  Future<String> _getValidRefreshToken(TokenManager tokenManager) async {
    final token = await tokenManager.getRefreshToken();
    if (token == null) {
      appLogger.error('Không tìm thấy refresh token');
      throw TokenRefreshException(TokenErrorMessages.refreshTokenIsNull);
    }
    return token;
  }

  Future<void> _validateApiResponse(Response response) async {
    final apiResponse = ApiResponse<TokenResponseDto>.fromJson(
      response.data,
      (_) => TokenResponseDto.fromJson(response as Map<String, dynamic>),
    );

    if (apiResponse.isFailure && _isSessionInvalid(apiResponse.status_code)) {
      throw TokenRefreshException(
        TokenErrorMessages.failedToRefreshAccessToken,
      );
    }

    if (!successCodes.contains(response.statusCode)) {
      throw TokenRefreshException(
        TokenErrorMessages.failedToRefreshAccessToken,
      );
    }
  }

  bool _isSessionInvalid(int? statusCode) {
    return AppErrorCode.SESSION_NOT_FOUND.value == statusCode ||
        AppErrorCode.TOKEN_REVOKED.value == statusCode;
  }

  TokenResponseData _extractAndValidateTokens(Response response) {
    final tokens = tokenExtractor(response);
    if (tokens.accessToken == null) {
      throw TokenRefreshException(
        TokenErrorMessages.failedToExtractAccessToken,
      );
    }
    return tokens;
  }

  Future<void> _updateTokenSession(
    TokenManager tokenManager,
    TokenResponseData tokens,
  ) async {
    await tokenManager.updateSession(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresIn: tokens.expiresIn,
      expiresAt: tokens.expiresAt,
    );
  }

  @override
  bool shouldRefreshToken(Response response) {
    final apiResponse = fromResponse(
      response,
      (json) => json as Map<String, dynamic>?,
    );
    if (ExcludeRefreshApiCode.excludeRefreshApiCode(
      apiResponse.errorCode ?? apiResponse.message,
    )) {
      return false;
    }
    return refreshCodes.contains(response.statusCode);
  }

  @override
  Map<String, String> getAuthorizationHeaders(String accessToken) {
    return authTemplate.map((key, value) => MapEntry(key, value + accessToken));
  }
}
