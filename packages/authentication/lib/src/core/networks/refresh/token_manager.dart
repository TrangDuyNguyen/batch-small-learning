import 'package:authentication/src/core/networks/refresh/refresh_module.dart';
import 'package:local_auth/local_auth.dart';

import '../../../data/datasource/datasource_module.dart';

/// The TokenManager interface defines the contract for managing access and
/// refresh tokens. It includes methods for retrieving, saving, and clearing
/// both types of tokens.
abstract class TokenManager {
  /// Retrieves the access token.
  ///
  /// Returns the access token as a [String], or null if it doesn't exist.
  Future<String?> getAccessToken();

  /// Saves the access token.
  ///
  /// Takes the access token as a [String] and saves it.
  Future<void> saveAccessToken(String token);

  /// Clears the access token.
  Future<void> clearAccessToken();

  /// Retrieves the refresh token.
  ///
  /// Returns the refresh token as a [String], or null if it doesn't exist.
  Future<String?> getRefreshToken();

  /// Saves the refresh token.
  ///
  /// Takes the refresh token as a [String] and saves it.
  Future<void> saveRefreshToken(String token);

  /// Clears the refresh token.
  Future<void> clearRefreshToken();

  /// Clears both access and refresh tokens.
  Future<void> clearTokens() async {
    await clearAccessToken();
    await clearRefreshToken();
  }

  Future<void> updateSession({
    String? accessToken,
    String? refreshToken,
    String? expiresIn,
    String? expiresAt,
  });
}

/// Interface quản lý public token
abstract class PublicTokenManager {
  /// Get public token
  Future<String?> getPublicToken();

  /// Save public token
  Future<void> savePublicToken(String token);

  /// Clear public token
  Future<void> clearPublicToken();

  /// Check if public token exists and is valid
  Future<bool> hasValidPublicToken();
}

/// The TokenManagerImpl class provides a concrete implementation of the
/// [TokenManager] interface, using [CredentialsDTS] to securely manage
/// access and refresh tokens.
class TokenManagerImpl implements TokenManager, PublicTokenManager {
  TokenManagerImpl(this._storage);
  final CredentialsDTS _storage;

  /// Retrieves the access token from credentials storage.
  ///
  /// Throws a [TokenManagerException] if an error occurs during retrieval.
  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.getAccessToken();
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToGetAccessToken);
    }
  }

  /// Saves the access token to credentials storage.
  ///
  /// Throws a [TokenManagerException] if an error occurs during saving.
  @override
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.updateAccessToken(token);
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToSaveAccessToken);
    }
  }

  /// Clears the access token from credentials storage.
  ///
  /// Throws a [TokenManagerException] if an error occurs during clearing.
  @override
  Future<void> clearAccessToken() async {
    try {
      // We use clearCredentials with keepPublicToken=true to only clear access token
      await _storage.clearCredentials(keepPublicToken: true);
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToClearAccessToken);
    }
  }

  /// Retrieves the refresh token from credentials storage.
  ///
  /// Throws a [TokenManagerException] if an error occurs during retrieval.
  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.getRefreshToken();
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToGetRefreshToken);
    }
  }

  /// Saves the refresh token to credentials storage.
  ///
  /// Throws a [TokenManagerException] if an error occurs during saving.
  @override
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.updateRefreshToken(token);
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToSaveRefreshToken);
    }
  }

  /// Clears the refresh token from credentials storage.
  ///
  /// Throws a [TokenManagerException] if an error occurs during clearing.
  @override
  Future<void> clearRefreshToken() async {
    try {
      await _storage.clearCredentials(keepPublicToken: true);
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToClearRefreshToken);
    }
  }

  /// Clears both the access and refresh tokens from credentials storage,
  /// maintaining the public token by default.
  @override
  Future<void> clearTokens() async {
    try {
      await _storage.clearCredentials(keepPublicToken: true);
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToClearAccessToken);
    }
  }

  /// Retrieves the public token from credentials storage.
  ///
  /// Throws a [TokenManagerException] if an error occurs during retrieval.
  @override
  Future<String?> getPublicToken() async {
    try {
      return await _storage.getPublicToken();
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToGetPublicToken);
    }
  }

  /// Saves the public token to credentials storage.
  ///
  /// Throws a [TokenManagerException] if an error occurs during saving.
  @override
  Future<void> savePublicToken(String token) async {
    try {
      await _storage.updatePublicToken(token);
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToSavePublicToken);
    }
  }

  /// Clears the public token from credentials storage.
  ///
  /// Throws a [TokenManagerException] if an error occurs during clearing.
  @override
  Future<void> clearPublicToken() async {
    try {
      await _storage.clearCredentials(keepPublicToken: false);
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToClearPublicToken);
    }
  }

  /// Checks if there is a valid public token in storage.
  ///
  /// Returns true if a non-null, non-empty token exists, false otherwise.
  @override
  Future<bool> hasValidPublicToken() async {
    try {
      final token = await getPublicToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> updateSession({
    String? accessToken,
    String? refreshToken,
    String? expiresIn,
    String? expiresAt,
  }) async {
    try {
      if (accessToken != null) {
        await _storage.updateAccessToken(accessToken);
      }
      if (refreshToken != null) {
        await _storage.updateRefreshToken(refreshToken);
      }
      if (expiresIn != null) {
        await _storage.updateExpiresIn(expiresIn);
      }
      if (expiresAt != null) {
        await _storage.updateExpiresAt(expiresAt);
      }
    } catch (e) {
      throw TokenManagerException(TokenErrorMessages.failedToSaveRefreshToken);
    }
  }
}

class SecureTokenManagerImpl implements TokenManager, PublicTokenManager {
  SecureTokenManagerImpl(this._delegate) : _localAuth = LocalAuthentication();
  final TokenManagerImpl _delegate;
  final LocalAuthentication _localAuth;

  /// Kiểm tra và yêu cầu xác thực local
  Future<bool> _authenticate() async {
    try {
      final canAuthenticate =
          await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        throw TokenManagerException(
          'Device does not support local authentication',
        );
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason:
            'Phiên làm việc đã hết hạn, vui lòng xác thực để tiếp tục',
        options: const AuthenticationOptions(
          stickyAuth: false,
          biometricOnly: false,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      throw TokenManagerException('Failed to authenticate: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    final isAuthenticated = await _authenticate();
    if (!isAuthenticated) {
      throw TokenManagerException(TokenErrorMessages.failedToGetRefreshToken);
    }
    return _delegate.getRefreshToken();
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    final isAuthenticated = await _authenticate();
    if (!isAuthenticated) {
      throw TokenManagerException(TokenErrorMessages.failedToSaveRefreshToken);
    }
    return _delegate.saveRefreshToken(token);
  }

  // Delegate other methods that don't need authentication
  @override
  Future<String?> getAccessToken() => _delegate.getAccessToken();

  @override
  Future<void> saveAccessToken(String token) =>
      _delegate.saveAccessToken(token);

  @override
  Future<void> clearAccessToken() => _delegate.clearAccessToken();

  @override
  Future<void> clearRefreshToken() => _delegate.clearRefreshToken();

  @override
  Future<void> clearTokens() => _delegate.clearTokens();

  @override
  Future<String?> getPublicToken() => _delegate.getPublicToken();

  @override
  Future<void> savePublicToken(String token) =>
      _delegate.savePublicToken(token);

  @override
  Future<void> clearPublicToken() => _delegate.clearPublicToken();

  @override
  Future<bool> hasValidPublicToken() => _delegate.hasValidPublicToken();

  @override
  Future<void> updateSession({
    String? accessToken,
    String? refreshToken,
    String? expiresIn,
    String? expiresAt,
  }) {
    // TODO: implement updateSession
    throw UnimplementedError();
  }
}
