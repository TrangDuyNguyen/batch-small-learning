import '../../../../authentication_module.dart';

abstract class ExcludeRefreshApiCode {
  /// Check if the API code should not be refreshed
  static List<AppErrorCode> values = [AppErrorCode.UNAUTHORIZED];
  static bool excludeRefreshApiCode(String? errorCode) {
    return values.map((code) => code.value).contains(errorCode);
  }
}

class HttpStatusConstraint {
  static bool isValid(int? status) {
    if (status == null) return false;
    return (status >= 200 && status < 300) || (status >= 400 && status <= 402);
  }
}
