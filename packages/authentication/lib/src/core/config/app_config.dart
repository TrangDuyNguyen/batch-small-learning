class AppConfig {
  AppConfig._();

  static final AppConfig _instance = AppConfig._();

  factory AppConfig() => _instance;

  // Network configuration
  static Duration connectTimeout = const Duration(seconds: 30);
  static Duration receiveTimeout = const Duration(seconds: 30);
  static bool showLogs = true;

  // Network logger configuration
  static bool showRequestHeader = true;
  static bool showResponseHeader = false;
  static bool showResponseBody = true;
  static bool showRequestBody = true;
  static bool showDioError = true;
  static bool compact = false;
  static bool isPrintJsonResponse = true;
  static String defaultLanguage = 'vi_VN';
  static String defaultLocaleName = 'vi_VN';
  static String currentLocaleName = 'vi_VN';

  //static String get getEnv => Environment.env;

  static String get getBaseUrl => '';

  //static String get getClientId => Environment.clientId;

  //static String get getClientSecret => Environment.clientSecret;

  static bool get debugMode => true;

  static bool get pharse2 => false;

  static Duration tokenExpiredThreshold = const Duration(seconds: 1);

  AppConfig copyWith({
    String? env,
    String? baseUrl,
    String? clientId,
    String? clientSecret,
    String? s3CredentialsKey,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    bool? showLogs,
    String? defaultLanguage,
    bool? showRequestHeader,
    bool? showResponseHeader,
    bool? showResponseBody,
    bool? showRequestBody,
    bool? showDioError,
    bool? compact,
    bool? isPrintJsonResponse,
  }) {
    AppConfig.showLogs = showLogs ?? AppConfig.showLogs;
    AppConfig.connectTimeout = connectTimeout ?? AppConfig.connectTimeout;
    AppConfig.receiveTimeout = receiveTimeout ?? AppConfig.receiveTimeout;
    AppConfig.showRequestHeader =
        showRequestHeader ?? AppConfig.showRequestHeader;
    AppConfig.showResponseHeader =
        showResponseHeader ?? AppConfig.showResponseHeader;
    AppConfig.showResponseBody = showResponseBody ?? AppConfig.showResponseBody;
    AppConfig.showRequestBody = showRequestBody ?? AppConfig.showRequestBody;
    AppConfig.showDioError = showDioError ?? AppConfig.showDioError;
    AppConfig.compact = compact ?? AppConfig.compact;
    AppConfig.isPrintJsonResponse =
        isPrintJsonResponse ?? AppConfig.isPrintJsonResponse;
    AppConfig.defaultLanguage = defaultLanguage ?? AppConfig.defaultLanguage;
    return AppConfig();
  }

  @override
  String toString() {
    return 'AppConfig('
        'connectTimeout: $connectTimeout, '
        'receiveTimeout: $receiveTimeout, '
        'showLogs: $showLogs, '
        'showRequestHeader: $showRequestHeader, '
        'showResponseHeader: $showResponseHeader, '
        'showResponseBody: $showResponseBody, '
        'showRequestBody: $showRequestBody, '
        'showDioError: $showDioError, '
        'compact: $compact, '
        'isPrintJsonResponse: $isPrintJsonResponse, '
        'defaultLanguage: $defaultLanguage'
        ')';
  }
}
