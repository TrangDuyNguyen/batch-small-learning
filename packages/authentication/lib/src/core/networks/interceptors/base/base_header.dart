import 'package:dio/dio.dart';

/// Base interface for all header interceptors
abstract class BaseHeaderInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  );
}

/// Base decorator class that implements the base interceptor interface
abstract class HeaderInterceptorDecorator extends BaseHeaderInterceptor {
  HeaderInterceptorDecorator(this._interceptor);

  final BaseHeaderInterceptor _interceptor;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Modify headers before delegating to wrapped interceptor
    await modifyHeaders(options);
    // Delegate to wrapped interceptor
    await _interceptor.onRequest(options, handler);
  }

  /// Template method for decorators to modify headers
  Future<void> modifyHeaders(RequestOptions options);
}

/// Concrete implementation of base header interceptor
class BasicHeaderInterceptor extends BaseHeaderInterceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Base implementation just calls handler.next()
    handler.next(options);
  }
}
