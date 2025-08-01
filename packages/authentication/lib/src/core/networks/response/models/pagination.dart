import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginatedResponse<T extends Object> {
  PaginatedResponse({
    required this.data,
    required this.total,
    required this.offset,
    required this.limit,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedResponseFromJson(json, fromJsonT);
  final List<T> data;
  final int total;
  final int offset;
  final int limit;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedResponseToJson(this, toJsonT);
}

@JsonSerializable(genericArgumentFactories: true)
class PaginatedRsResponse<T extends Object> {
  PaginatedRsResponse({
    required this.results,
    required this.total,
    required this.offset,
    required this.count,
  });

  factory PaginatedRsResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$PaginatedRsResponseFromJson(json, fromJsonT);
  final List<T> results;
  final int total;
  final int offset;
  final int count;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$PaginatedRsResponseToJson(this, toJsonT);
}
