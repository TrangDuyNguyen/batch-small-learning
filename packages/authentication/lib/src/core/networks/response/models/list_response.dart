import 'package:freezed_annotation/freezed_annotation.dart';
part 'list_response.freezed.dart';
part 'list_response.g.dart';

@Freezed(genericArgumentFactories: true)
class ListData<T> with _$ListData<T> {
  const factory ListData({
    int? total,
    List<T>? data,
  }) = _ListData;

  factory ListData.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ListDataFromJson(json, fromJsonT);
}

@Freezed(genericArgumentFactories: true)
class ListResult<T> with _$ListResult<T> {
  const factory ListResult({
    int? total,
    int? count,
    int? offset,
    List<T>? results,
  }) = _ListResult;

  factory ListResult.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ListResultFromJson(json, fromJsonT);
}

extension ListDataOptionX<T> on ListData<T> {
  /// parse to Failure if response is not success
  List<T> getOrEmpty() {
    return data ?? [];
  }

  List<T> get itemsOrEmpty {
    return data ?? [];
  }

  List<T>? get items {
    return data;
  }

  ListData<R> map<R>(R Function(T) f) {
    return ListData<R>(
      total: total,
      data: data?.map(f).toList(),
    );
  }
}
