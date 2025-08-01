import 'api_response.dart';

extension ApiResponseX<T> on ApiResponse<T> {
  /// Kiểm tra response có rỗng không
  bool get isEmpty => data == null;

  /// Kiểm tra response có dữ liệu không
  bool get isNotEmpty => data != null;

  /// Kiểm tra API call thất bại
  bool get isFailure => !isNetworkSuccess();

  /// Lấy thông tin chi tiết lỗi
  String get detailedErrorMessage => errorDetails ?? message ?? 'Có lỗi xảy ra';

  T? get dataOrNull => isNetworkSuccess() ? data : null;

  bool get isSuccess => isNetworkSuccess() && data != null;
}
