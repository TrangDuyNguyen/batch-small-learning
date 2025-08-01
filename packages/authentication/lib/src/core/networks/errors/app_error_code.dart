import 'package:collection/collection.dart';

import 'errors_module.dart';

/// Unified error code system for the entire application.
///
/// Each error has:
/// - A descriptive identifier (id)
/// - A numeric code for API compatibility (numericCode)
/// - A default message in English
///
/// Errors are organized by domain/module for better maintainability.
enum AppErrorCode implements ErrorCode {
  // === GENERAL ERRORS ===
  UNEXPECTED_ERROR(
    'UNEXPECTED_ERROR',
    '000',
    'An unexpected error occurred',
  ),
  BAD_REQUEST(
    'BAD_REQUEST',
    '100',
    'Bad request',
  ),
  PARSE_ERROR(
    'GENERAL_PARSE_ERROR',
    '001',
    'Parse data failed',
  ),
  CONNECTION_ERROR(
    'GENERAL_CONNECTION_ERROR',
    '002',
    'Connection error',
  ),
  CANCEL(
    'GENERAL_CANCEL',
    '003',
    'Canceled',
  ),
  INVALID_MESSAGE(
    'GENERAL_INVALID_MESSAGE',
    '004',
    'Message validation failed',
  ),

  // === NETWORK ERRORS ===
  NETWORK_ERROR(
    'NETWORK_ERROR',
    '005',
    'Network error',
  ),

  INTERNAL_SERVER_ERROR(
    'GENERAL_INTERNAL_SERVER_ERROR',
    '500',
    'Internal server error',
  ),

  // === AUTHENTICATION ERRORS ===
  UNAUTHORIZED(
    'AUTH_UNAUTHORIZED',
    '200',
    'Unauthorized access',
  ),
  TOKEN_REVOKED(
    'AUTH_TOKEN_REVOKED',
    '205',
    'Token has been revoked',
  ),
  SESSION_NOT_FOUND(
    'AUTH_SESSION_NOT_FOUND',
    '206',
    'Session not found',
  ),
  TOKEN_INVALID(
    'AUTH_TOKEN_INVALID',
    '207',
    'Invalid token',
  ),

  // === USER ACCOUNT ERRORS ===
  USER_NOT_FOUND(
    'USER_NOT_FOUND',
    '300',
    'User not found',
  ),
  USER_ALREADY_EXISTS(
    'USER_ALREADY_EXISTS',
    '301',
    'User already exists',
  ),
  USER_BANNED(
    'USER_BANNED',
    '302',
    'Account has been banned',
  ),
  USER_SSO_MANAGED(
    'USER_SSO_MANAGED',
    '303',
    'Account is managed by SSO',
  ),
  EMAIL_EXISTS(
    'USER_EMAIL_EXISTS',
    '304',
    'Email is already in use',
  ),
  PHONE_EXISTS(
    'USER_PHONE_EXISTS',
    '305',
    'Phone number is already in use',
  ),
  WEAK_PASSWORD(
    'USER_WEAK_PASSWORD',
    '306',
    'Password is not strong enough',
  ),
  SAME_PASSWORD(
    'USER_SAME_PASSWORD',
    '307',
    'New password must be different from old password',
  ),
  ACCOUNT_INACTIVE(
    'USER_ACCOUNT_INACTIVE',
    '308',
    'Account is not active',
  ),
  ACCOUNT_DELETED(
    'USER_ACCOUNT_DELETED',
    '309',
    'Account has been deleted',
  ),

  // === REGISTRATION ERRORS ===
  REGISTER_EXSIST(
    'REGISTER_EXSIST',
    '101',
    'Registration already exists',
  ),
  REGISTER_NOT_EXSIST(
    'REGISTER_NOT_EXSIST',
    '102',
    'Registration does not exist',
  ),
  REGISTER_UNACTIVE(
    'REGISTER_UNACTIVE',
    '112',
    'Account is not activated',
  ),

  // === VERIFICATION ERRORS ===
  EMAIL_NOT_CONFIRMED(
    'VERIFY_EMAIL_NOT_CONFIRMED',
    '401',
    'Email is not confirmed',
  ),
  PHONE_NOT_CONFIRMED(
    'VERIFY_PHONE_NOT_CONFIRMED',
    '402',
    'Phone number is not confirmed',
  ),
  EMAIL_ADDRESS_INVALID(
    'VERIFY_EMAIL_INVALID',
    '403',
    'Invalid email address',
  ),
  EMAIL_PASS_NOT_MATCH(
    'VERIFY_EMAIL_PASS_NOT_MATCH',
    '104',
    'Email and password do not match',
  ),

  // === OTP ERRORS ===
  OTP_EXPIRED(
    'OTP_EXPIRED',
    '501',
    'OTP has expired',
  ),
  OTP_DISABLED(
    'OTP_DISABLED',
    '502',
    'OTP is disabled',
  ),
  REQUIRE_VERIFY_OTP(
    'OTP_VERIFY_REQUIRED',
    '503',
    'OTP verification required',
  ),
  MISMATCH_OTP(
    'OTP_MISMATCH',
    '504',
    'Incorrect OTP code',
  ),
  OVER_WRONG_OTP(
    'OTP_OVER_WRONG',
    '505',
    'Too many incorrect OTP attempts',
  ),
  OVER_REGENERATION_OTP(
    'OTP_OVER_REGENERATION',
    '506',
    'Too many OTP regeneration attempts',
  ),
  OTP_5MIN(
    'OTP_5MIN',
    '103',
    'OTP 5 minute limit',
  ),
  OTP_LIMIT(
    'OTP_LIMIT',
    '107',
    'Exceeded daily OTP send limit',
  ),
  OTP_ERROR(
    'OTP_ERROR',
    '108',
    'Error occurred during OTP verification',
  ),

  // === LOGIN ERRORS ===
  LOGIN_INVALID(
    'LOGIN_INVALID',
    '201',
    'Invalid login',
  ),
  LOGIN_UNACTIVE(
    'LOGIN_UNACTIVE',
    '202',
    'Account is not activated',
  ),
  LOGIN_SOFT_DELETED(
    'LOGIN_SOFT_DELETED',
    '203',
    'Account has been soft-deleted',
  ),
  LOGIN_DELETED(
    'LOGIN_DELETED',
    '204',
    'Account has been deleted',
  ),
  LOGIN_BLOCK(
    'LOGIN_BLOCK',
    '205',
    'Account has been blocked',
  ),
  LOGIN_TEMP_BLOCK(
    'LOGIN_TEMP_BLOCK',
    '206',
    'Account has been temporarily blocked',
  ),

  // === RATE LIMIT ERRORS ===
  OVER_REQUEST_RATE_LIMIT(
    'RATE_OVER_REQUEST',
    '601',
    'Request rate limit exceeded',
  ),
  OVER_EMAIL_SEND_RATE_LIMIT(
    'RATE_OVER_EMAIL',
    '602',
    'Email send rate limit exceeded',
  ),
  OVER_SMS_SEND_RATE_LIMIT(
    'RATE_OVER_SMS',
    '603',
    'SMS send rate limit exceeded',
  ),

  // === PERMISSION ERRORS ===
  NOT_PERMISSION(
    'PERM_NOT_PERMISSION',
    '701',
    'No permission to perform this operation',
  ),
  NOT_ADMIN_ACCOUNT(
    'PERM_NOT_ADMIN',
    '702',
    'Not an admin account',
  ),

  // === API/CLIENT ERRORS ===
  API_KEY_EXPIRED(
    'API_KEY_EXPIRED',
    '801',
    'API key has expired',
  ),
  CLIENT_NOT_FOUND(
    'CLIENT_NOT_FOUND',
    '802',
    'Client not found',
  ),
  CLIENT_EXPIRED(
    'CLIENT_EXPIRED',
    '803',
    'Client has expired',
  ),
  CLIENT_INACTIVE(
    'CLIENT_INACTIVE',
    '804',
    'Client is inactive',
  ),
  TOKEN(
    'TOKEN',
    '600',
    'Invalid token',
  ),

  // === CONTENT ERRORS ===
  DATA_NOT_FOUND(
    'CONTENT_DATA_NOT_FOUND',
    '901',
    'Data not found',
  ),
  NO_CONTENT_DATA(
    'CONTENT_NO_CONTENT',
    '902',
    'No content data',
  ),

  // === FLOW ERRORS ===
  FLOW_STATE_NOT_FOUND(
    'FLOW_STATE_NOT_FOUND',
    '1001',
    'Flow state not found',
  ),
  FLOW_STATE_EXPIRED(
    'FLOW_STATE_EXPIRED',
    '1002',
    'Flow state has expired',
  ),

  // === CONFLICT ERRORS ===
  CONFLICT(
    'CONFLICT',
    '1101',
    'Data conflict',
  ),

  // === VALIDATION ERRORS ===
  EMAIL(
    'VALIDATION_EMAIL',
    '601',
    'Invalid email',
  ),
  PASSWORD(
    'VALIDATION_PASSWORD',
    '602',
    'Invalid password',
  ),
  FIRST_NAME(
    'VALIDATION_FIRST_NAME',
    '603',
    'Invalid first name',
  ),
  LAST_NAME(
    'VALIDATION_LAST_NAME',
    '604',
    'Invalid last name',
  ),
  DEVICE_ID(
    'VALIDATION_DEVICE_ID',
    '605',
    'Invalid device ID',
  ),
  DEVICE_NAME(
    'VALIDATION_DEVICE_NAME',
    '606',
    'Invalid device name',
  ),
  TITLE(
    'VALIDATION_TITLE',
    '607',
    'Invalid title',
  ),
  LAST_ID(
    'VALIDATION_LAST_ID',
    '608',
    'Invalid last ID',
  ),
  LIMIT(
    'VALIDATION_LIMIT',
    '609',
    'Invalid limit',
  ),
  TYPE(
    'VALIDATION_TYPE',
    '610',
    'Invalid type',
  ),
  CONTENT(
    'VALIDATION_CONTENT',
    '611',
    'Invalid content',
  ),
  CODE(
    'VALIDATION_CODE',
    '612',
    'Invalid code',
  ),
  PHONE(
    'VALIDATION_PHONE',
    '613',
    'Invalid phone number',
  ),
  AVATAR(
    'VALIDATION_AVATAR',
    '614',
    'Invalid avatar',
  ),
  COVER(
    'VALIDATION_COVER',
    '615',
    'Invalid cover',
  ),

  // === ROOM/CHAT ERRORS ===
  ROOM_NOT_FOUND(
    'ROOM_NOT_FOUND',
    '1201',
    'Chat room not found',
  ),
  MESSAGE_LIMIT(
    'ROOM_MESSAGE_LIMIT',
    '403',
    'Message limit exceeded',
  ),
  NO_ROOM_ID(
    'ROOM_NO_ID',
    '110',
    'No room ID',
  ),

  // === AI ERRORS ===
  AI_RESPONSE_ERROR(
    'AI_RESPONSE_ERROR',
    '105',
    'AI response error',
  ),
  USAGE_LIMIT(
    'AI_USAGE_LIMIT',
    '106',
    'Usage limit exceeded',
  ),
  UPLOAD_EXT_ERROR(
    'AI_UPLOAD_EXT_ERROR',
    '109',
    'Upload extension error',
  ),

  // === NFT/BLOCKCHAIN ERRORS ===
  BSC_ADDRESS_NOTFOUND(
    'BSC_ADDRESS_NOTFOUND',
    '115',
    'BSC address not found',
  ),
  ARTICLE_NOTFOUND(
    'ARTICLE_NOTFOUND',
    '116',
    'Article not found',
  ),
  ARTICLE_MINTED(
    'ARTICLE_MINTED',
    '117',
    'Article already minted',
  ),
  ARTICLE_OWNER_ERROR(
    'ARTICLE_OWNER_ERROR',
    '118',
    'Article owner error',
  ),
  BAD_EVM_ADDRESS_ERROR(
    'BAD_EVM_ADDRESS_ERROR',
    '119',
    'Bad EVM address error',
  ),
  MINT_NFT_ERROR(
    'MINT_NFT_ERROR',
    '120',
    'Mint NFT error',
  ),;

  /// Descriptive identifier for the error code
  final String id;

  /// Numeric code for API compatibility
  final String numericCode;

  @override
  final String defaultMessage;

  @override
  final String value;

  const AppErrorCode(
    this.id,
    this.numericCode,
    this.defaultMessage,
  ) : value = id;

  /// Creates a [Failure] from this error code
  @override
  Failure toFailure({
    String? message,
    String? errorCode,
    Map<String, dynamic>? extras,
  }) {
    return Failure(
      errorCode: this,
      message: message ?? defaultMessage,
      errorsMetadata: extras ?? {},
    );
  }

  /// Find an error code by its descriptive ID
  static AppErrorCode? fromId(String? id) {
    if (id == null) return null;
    return AppErrorCode.values.firstWhereOrNull((e) => e.id == id);
  }

  /// Find an error code by its numeric code
  static AppErrorCode? fromNumericCode(String? code) {
    if (code == null) return null;
    return AppErrorCode.values.firstWhereOrNull((e) => e.numericCode == code);
  }

  /// Find an error code by either ID or numeric code
  static AppErrorCode? fromCode(String? code) {
    if (code == null) return null;
    return fromId(code) ?? fromNumericCode(code);
  }

  /// Check if this error is an authentication error
  bool get isAuthError => id.startsWith('AUTH_');

  /// Check if this error is a token error
  bool get isTokenError {
    return this == TOKEN_REVOKED ||
        this == SESSION_NOT_FOUND ||
        this == TOKEN_INVALID ||
        this == TOKEN;
  }

  /// Check if this error is an OTP error
  bool get isOtpError => id.startsWith('OTP_');

  /// Check if this error is a validation error
  bool get isValidationError => id.startsWith('VALIDATION_');
}
