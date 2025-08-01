import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../config/app_config.dart';
import '../errors/error_mapper.dart';
import '../interceptors/base/base.dart';
import '../interceptors/errors/error_code_mapper.dart';
import '../interceptors/headers/headers.dart';

class RestAPIConfig {
  const RestAPIConfig({
    required this.parseErrorCode,
    this.auth,
    this.headerProcessor,
    this.logger,
    this.cookies,
    this.retry,
    this.extras = const [],
    this.isRetryEnabled = false,
    this.responseType = ResponseType.json,
  });

  factory RestAPIConfig.withRetry({
    required Interceptor parseErrorCode,
    RetryConfig? retryConfig,
    Interceptor? auth,
    Interceptor? headerProcessor,
    Interceptor? logger,
    List<Interceptor> extras = const [],
  }) {
    return RestAPIConfig(
      parseErrorCode: parseErrorCode,
      auth: auth,
      headerProcessor: headerProcessor,
      logger: logger,
      retry: RetryInterceptor(
        dio: Dio(),
        // Will be replaced when added to actual Dio instance
        retries: retryConfig?.retries ?? 3,
        retryDelays:
            retryConfig?.delays ??
            const [
              Duration(seconds: 1),
              Duration(seconds: 3),
              Duration(seconds: 5),
            ],
        retryableExtraStatuses:
            retryConfig?.retryAbleStatuses ??
            {
              403, // Forbidden
              408, // Request Timeout
              429, // Too Many Requests
              500, // Internal Server Error
              502, // Bad Gateway
              503, // Service Unavailable
              504, // Gateway Timeout
            },
        logPrint: (message) {},
      ),
      extras: extras,
    );
  }

  final Interceptor parseErrorCode;
  final Interceptor? auth;
  final Interceptor? headerProcessor;
  final Interceptor? logger;
  final CookieManager? cookies;
  final RetryInterceptor? retry;
  final List<Interceptor> extras;
  final ResponseType responseType;
  final bool isRetryEnabled;

  List<Interceptor> get orderedInterceptors => [
    if (auth != null) auth!,
    if (headerProcessor != null) headerProcessor!,
    if (cookies != null) cookies!,
    if (retry != null) retry!,
    ...extras,
    if (logger != null) logger!,
    parseErrorCode,
  ];

  RestAPIConfig copyWith({
    Interceptor? parseErrorResponseIter,
    Interceptor? authIter,
    Interceptor? headerProcessor,
    Interceptor? logger,
    CookieManager? cookies,
    RetryInterceptor? retry,
    List<Interceptor>? extras,
    bool? isRetryEnabled,
    ResponseType? responseType,
  }) {
    return RestAPIConfig(
      parseErrorCode: parseErrorResponseIter ?? this.parseErrorCode,
      auth: authIter ?? this.auth,
      headerProcessor: headerProcessor ?? this.headerProcessor,
      logger: logger ?? this.logger,
      cookies: cookies ?? this.cookies,
      retry: retry ?? this.retry,
      extras: extras ?? this.extras,
      isRetryEnabled: isRetryEnabled ?? this.isRetryEnabled,
      responseType: responseType ?? this.responseType,
    );
  }
}

/// Configuration for retry behavior
class RetryConfig {
  const RetryConfig({
    this.retries = 3,
    this.delays = const [
      Duration(seconds: 1),
      Duration(seconds: 3),
      Duration(seconds: 5),
    ],
    this.retryAbleStatuses = const {403, 408, 429, 500, 502, 503, 504},
  });

  /// Quick configuration for common scenarios
  factory RetryConfig.standard() => const RetryConfig();

  factory RetryConfig.aggressive() => const RetryConfig(
    retries: 5,
    delays: [
      Duration(milliseconds: 500),
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
      Duration(seconds: 5),
    ],
  );

  factory RetryConfig.minimal() => const RetryConfig(
    retries: 1,
    delays: [Duration(seconds: 2)],
    retryAbleStatuses: {500, 502, 503, 504},
  );
  final int retries;
  final List<Duration> delays;
  final Set<int> retryAbleStatuses;
}

class DefaultRestAPIConfig extends RestAPIConfig {
  DefaultRestAPIConfig({
    Interceptor? parseErrorResponseIter,
    super.auth,
    Interceptor? headerProcessorIter,
    RetryConfig? retryConfig,
    super.extras,
    bool isRetryEnabled = false,
    super.responseType,
  }) : super(
         parseErrorCode:
             parseErrorResponseIter ??
             ErrorParseInterceptor(AppErrorCodeMapper()),
         headerProcessor:
             headerProcessorIter ??
             UserAgentHeaderInterceptor(BasicHeaderInterceptor()),
         logger:
             AppConfig.showLogs
                 ? PrettyDioLogger(
                   requestHeader: AppConfig.showRequestHeader,
                   requestBody: AppConfig.showRequestBody,
                   responseBody: AppConfig.showResponseBody,
                   responseHeader: AppConfig.showResponseHeader,
                   error: AppConfig.showDioError,
                   compact: AppConfig.compact,
                   maxWidth: 100,
                 )
                 : null,
         retry:
             isRetryEnabled
                 ? RetryInterceptor(
                   dio:
                       Dio(), // Will be replaced when added to actual Dio instance
                   retries: retryConfig?.retries ?? 3,
                   retryDelays:
                       retryConfig?.delays ?? RetryConfig.standard().delays,
                   retryableExtraStatuses:
                       retryConfig?.retryAbleStatuses ??
                       RetryConfig.standard().retryAbleStatuses,
                 )
                 : null,
       );
}
