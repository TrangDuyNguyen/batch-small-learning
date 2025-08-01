import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_res.freezed.dart';

part 'login_res.g.dart';

@freezed
class LoginRes with _$LoginRes {
  factory LoginRes({
    String? uid,
    int? provider,
    String? providerId,
    String? email,
    String? avatar,
    String? cover,
    String? firstName,
    String? lastName,
    int? state,
    int? role,
    String? subExpires,
    String? deviceId,
    List<int>? categories,
    List<int>? permission,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'access_token') String? accessToken,
  }) = _LoginRes;

  factory LoginRes.fromJson(Map<String, dynamic> json) =>
      _$LoginResFromJson(json);
}


