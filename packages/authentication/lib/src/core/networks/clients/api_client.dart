import 'package:dio/dio.dart';

import '../../../../authentication.dart';

class DioClient {
  final Dio _dio;

  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AuthConstrainPath.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(request: true, responseBody: true, requestBody: true),
    );
  }

  Dio get instance => _dio;
}
