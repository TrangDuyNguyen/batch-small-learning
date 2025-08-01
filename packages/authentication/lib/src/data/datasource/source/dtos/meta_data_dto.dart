import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta_data_dto.freezed.dart';
part 'meta_data_dto.g.dart';

@freezed
class Metadata with _$Metadata {
  const factory Metadata({
    Map<String, Object>? variables, // Map of variables
    Map<String, Object>? params, // Map of params
    String? body, // Body content as a string
    Map<String, Object>? extend, // Additional extended metadata
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);
}
