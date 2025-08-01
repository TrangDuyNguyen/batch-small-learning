import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_res.freezed.dart';
part 'token_res.g.dart';

@Freezed()
class TokenRes with _$TokenRes {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory TokenRes({
    String? providerToken,
    String? providerRefreshToken,
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
    int? expiresAt,
    String? tokenType,
    UserRes? user,
  }) = _TokenRes;

  factory TokenRes.fromJson(Map<String, dynamic> json) =>
      _$TokenResFromJson(json);
}

@freezed
class UserRes with _$UserRes {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory UserRes({
    String? id,
    AppMetadata? appMetadata,
    Map<String, dynamic>? userMetadata,
    String? aud,
    DateTime? confirmationSentAt,
    DateTime? recoverySentAt,
    DateTime? emailChangeSentAt,
    String? newEmail,
    DateTime? invitedAt,
    String? actionLink,
    String? email,
    String? phone,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? emailConfirmedAt,
    DateTime? phoneConfirmedAt,
    DateTime? lastSignInAt,
    String? role,
    List<int>? permission,
    DateTime? updatedAt,
    List<dynamic>? identities,
    dynamic factors,
    bool? isAnonymous,
  }) = _UserRes;

  factory UserRes.fromJson(Map<String, dynamic> json) =>
      _$UserResFromJson(json);
}

@freezed
class AppMetadata with _$AppMetadata {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory AppMetadata({
    String? provider,
    List<String>? providers,
  }) = _AppMetadata;

  factory AppMetadata.fromJson(Map<String, dynamic> json) =>
      _$AppMetadataFromJson(json);
}
