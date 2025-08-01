import '../../../../../authentication_module.dart';

// Define constants for storage keys
abstract class CredentialsStorageKeys {
  // Các trường hiện tại
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String publicToken = 'public_token';
  static const String publicRefreshToken = 'public_refresh_token';
  static const String accountId = 'account_id';
  static const String tokenType = 'token_type';
  static const String expiresIn = 'expires_in';
  static const String expiresAt = 'expires_at';
  static const String lastUpdated = 'last_updated';
  static const String avatar = 'avatar';
  static const String userId = 'user_id';
  static const String providerToken = 'provider_token';
  static const String providerRefreshToken = 'provider_refresh_token';
  static const String provider = 'provider';
  static const String registerBio = 'register_bio';
  static const String user = 'user';
}

abstract class CredentialsDTS {
  // Core methods
  Future<void> saveCredentials(AuthSession credentials);

  Future<AuthSession?> getCredentials();

  Future<void> clearCredentials({bool keepPublicToken = true});

  // Token specific methods
  Future<void> updateAccessToken(String token);

  Future<void> updatePublicToken(String token);

  Future<void> updateRefreshToken(String token);

  Future<void> updateExpiresIn(String expiresIn);

  Future<void> updateExpiresAt(String expiresAt);

  Future<void> updateProviderToken(String token);

  Future<void> updateProviderRefreshToken(String token);

  Future<void> updateProvider(String providerName);

  Future<String?> getProviderToken();

  Future<String?> getProviderRefreshToken();

  Future<String?> getProvider();

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String?> getPublicToken();

  Future<void> updateUserId(String userId);

  Future<String?> getUserId();

  Future<bool> isTokenExpired();

  Future<bool> isRegisterBio({required String userId});

  Future<void> updateRegisterBio({
    required String userId,
    required bool isRegisterBio,
  });

  @deprecated
  Future<void> setTokenExpiry(Duration expiry);

  @deprecated
  Future<void> forceTokenExpiration();

  // Stream for credentials changes
  Stream<AuthSession> get credentialsStream;
}
