import 'package:dio/dio.dart';

import '../../../utils/client_hints.dart';
import '../base/base.dart';

/// User agent header decorator
class UserAgentHeaderInterceptor extends HeaderInterceptorDecorator {
  UserAgentHeaderInterceptor(super.interceptor);

  @override
  Future<void> modifyHeaders(RequestOptions options) async {
    options.headers.addAll(await userAgentClientHintsHeader());
  }
}
