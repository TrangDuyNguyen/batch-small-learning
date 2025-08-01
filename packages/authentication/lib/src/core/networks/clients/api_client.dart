import 'package:dio/dio.dart';
import '../../config/app_config.dart';
import '../../debug/app_logger.dart';
import '../interceptors/interceptors.dart';
import '../response/models/base_reponse.dart';
import 'client_config.dart';

/// Base API service with common functionality
abstract class RestAPIClient {
  RestAPIClient({required this.client});

  final RestAPI client;

  Dio get dio => client.dio;
}

/// Base API client with common functionality
class RestAPI {
  RestAPI({required this.restConfig, this.baseUrl, this.headers}) {
    _init();
  }

  late final Dio dio;
  final String? baseUrl;
  final Map<String, dynamic>? headers;
  final RestAPIConfig restConfig;

  void _init() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.getBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.connectTimeout,
        validateStatus: (status) {
          return NetworkStatusCode.successStatus.contains(status);
        },
        contentType: 'application/json',
        responseType: restConfig.responseType,
        headers: {...?headers},
      ),
    );

    // Add interceptors in specific order
    final interceptors = [
      ...restConfig.orderedInterceptors,
      // Debug logging first
      if (AppConfig.isPrintJsonResponse && AppConfig.debugMode)
        JsonLoggerInterceptor(),
    ];

    dio.interceptors.addAll(interceptors);
  }

  void dispose() {
    try {
      dio.close();
    } catch (e) {
      appLogger.debug('Error disposing dio client: $e');
    }
  }

  RestAPI copyWith({
    String? baseUrl,
    Map<String, dynamic>? headers,
    RestAPIConfig? restConfig,
  }) {
    return RestAPI(
      baseUrl: baseUrl ?? this.baseUrl,
      headers: headers ?? this.headers,
      restConfig: restConfig ?? this.restConfig,
    );
  }
}
