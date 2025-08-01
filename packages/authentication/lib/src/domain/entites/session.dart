import 'dart:ui';

import '../../../authentication_module.dart';
/// Memory session storage
/// This class is used to store the current session of the user
class Session {
  Session._();

  static AuthSession _mCredential = const AuthSession();

  static AuthSession get tokenPair => _mCredential;

  static void setCredentials(AuthSession credential) {
    _mCredential = credential;
  }

  static UserAccount? _mAccount;
  static UserAccount? get account => _mAccount;

  static void setAccount(UserAccount? account) {
    _mAccount = account;
    appLogger.warning('Account updated: ${account?.toJson()}');
  }

  // Set user ID directly in the session
  static void setUserById(String userId) {
    if (userId.isNotEmpty) {
      _mCredential = _mCredential.copyWith(userId: userId);
      appLogger.info('User assigned by ID: $userId');
    } else {
      appLogger.warning('Cannot assign empty user ID');
    }
  }

  // Set the target user ID in the session
  static void setTargetUser() {
    assert(_mCredential.userId != null, 'User ID is null');
    setUserById(_mCredential.userId ?? '');
    appLogger.info('Target user set in session');
  }

  // Check if current user is the target user
  static bool isTargetUser() {
    return Session.getCurrentUserId() == _mCredential.userId;
  }

  // Match user ID with target user
  static bool matchTargetUser() {
    if (isTargetUser()) {
      appLogger.info('Current user matches target user');
      return true;
    }
    return false;
  }

  // Methods for integration with UserMapper (from chat_core package)

  /// Check if the provided user ID matches current session user ID
  static bool matchesCurrentUserId(String userId) {
    return Session.getCurrentUserId() == userId;
  }

  /// Get the current session user ID for user matching
  static String getCurrentUserId() {
    final userId = _mCredential.userId;
    if (userId == null || userId.isEmpty) {
      // Default to target user if no ID is set
      setTargetUser();
      return targetUserId;
    }
    return userId;
  }

  static void clear() {
    _mCredential = _mCredential.copyWith(
      accessToken: null,
      refreshToken: null,
      accountId: null,
      userId: null,
    );
    _mAccount = null;
  }

  static void clearAccount() {
    _mAccount = null;
  }

  static Locale _mLocale = const Locale('vi', 'VN');

  static setLocale(Locale locale) {
    Session._mLocale = locale;
  }

  static String _mCurrencyCode = 'VND';
  static const String _mCurrencySymbol = '₫';

  static setCurrency(String value) {
    _mCurrencyCode = value;
  }

  //// target code
  static String get targetCurrencySymbol => _mCurrencySymbol;

  static Locale get targetLocale => _mLocale;

  static String get targetLocaleCode => _mLocale.languageCode;

  static String get targetCurrencyCode => _mCurrencyCode;

  static String get targetUserId => _mCredential.userId ?? '';

  static String get targetAccountId => _mCredential.accountId ?? '';

  static String get targetAccessToken =>
      _mCredential.accessToken ?? _mCredential.publicToken ?? '';

  static String get targetPublicToken => _mCredential.publicToken ?? '';

  static String get targetAccountName {
    // First try to get name from _mAccount (for updates)
    final accountName = _mAccount?.profile?.fullName;
    if (accountName != null && accountName.isNotEmpty) {
      return accountName;
    }

    final accountId = _mAccount?.identifier;
    if (accountId != null && accountId.isNotEmpty) {
      return accountId;
    }

    // Fallback to _mCredential (for initial load)
    final credentialName = _mCredential.user?.profile?.fullName;
    if (credentialName != null && credentialName.isNotEmpty) {
      return credentialName;
    }

    return _mCredential.user?.identifier ?? '';
  }

  static String get targetAvatar {
    // First try to get avatar from _mAccount (for updates)
    final accountAvatar = _mAccount?.avatar;
    if (accountAvatar != null && accountAvatar.isNotEmpty) {
      return accountAvatar;
    }

    // Fallback to _mCredential (for initial load)
    final credentialAvatar = _mCredential.user?.avatar;
    if (credentialAvatar != null && credentialAvatar.isNotEmpty) {
      return credentialAvatar;
    }

    return '';
  }


  static AuthSession get targetCredentials => _mCredential;

  static String get targetBearerToken => 'Bearer $targetAccessToken';

  static String get targetBearerPublicToken =>
      'Bearer ${_mCredential.publicToken}';
}
