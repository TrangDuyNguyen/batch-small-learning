import 'package:dio/dio.dart';
import 'token_error_messages.dart';
import 'token_exception.dart';
import 'token_manager.dart';

/// The PublicTokenStrategy interface defines the contract for handling public tokens.
/// This is simpler than TokenRefreshStrategy as it doesn't need refresh mechanism.
abstract class PublicTokenStrategy {
  /// Gets the public token using the provided [Dio] instance and [PublicTokenManager].
  Future<String?> getPublicToken(Dio dio, PublicTokenManager tokenManager);

  /// Gets the authorization headers using the provided public token.
  Map<String, String> getAuthorizationHeaders(String publicToken);

  /// Determines if the public token is invalid based on response.
  bool isInvalidToken(Response response);
}

/// Implementation of PublicTokenStrategy for handling public tokens
class PublicTokenStrategyImpl implements PublicTokenStrategy {
  /// Handler to get public token from API
  final Future<Response> Function(Dio dio) tokenHandler;

  /// Extracts public token from response
  final String? Function(Response response) tokenExtractor;

  /// Success status codes
  final List<int> successCodes;

  /// Invalid token status codes
  final List<int> invalidTokenCodes;

  /// Template for auth headers
  final Map<String, String> authTemplate;

  /// Creates a [PublicTokenStrategyImpl]
  PublicTokenStrategyImpl({
    required this.tokenHandler,
    required this.tokenExtractor,
    this.successCodes = const [200],
    this.invalidTokenCodes = const [401],
    this.authTemplate = const {'Authorization': 'Bearer '},
  });

  @override
  Future<String?> getPublicToken(
      Dio dio, PublicTokenManager tokenManager) async {
    try {
      // Try to get token from API
      final response = await tokenHandler(dio);

      if (successCodes.contains(response.statusCode)) {
        final publicToken = tokenExtractor(response);

        if (publicToken != null) {
          // Save new token
          await tokenManager.savePublicToken(publicToken);
          return publicToken;
        } else {
          throw TokenManagerException(
            TokenErrorMessages.failedToExtractAccessToken,
          );
        }
      } else {
        throw TokenManagerException(
          TokenErrorMessages.failedToGetPublicToken,
        );
      }
    } catch (e) {
      throw TokenManagerException(
        TokenErrorMessages.failedToGetPublicToken,
      );
    }
  }

  @override
  Map<String, String> getAuthorizationHeaders(String publicToken) {
    return authTemplate.map(
      (key, value) => MapEntry(key, value + publicToken),
    );
  }

  @override
  bool isInvalidToken(Response response) {
    return invalidTokenCodes.contains(response.statusCode);
  }
}
