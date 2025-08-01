import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_res.freezed.dart';

part 'me_res.g.dart';

@freezed
class MeRes with _$MeRes {
  factory MeRes({
    String? uid,
    int? provider,
    String? providerId,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
    String? cover,
    int? state,
    int? role,
    String? bsc,
    dynamic subExpires,
    List<int>? categories,
    List<int>? permission,
  }) = _MeRes;

  factory MeRes.fromJson(Map<String, dynamic> json) => _$MeResFromJson(json);
}
