import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../authentication_module.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

@freezed
class AuthSession with _$AuthSession {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AuthSession({
    String? accessToken,
    String? refreshToken,
    String? publicToken,
    String? publicRefreshToken,
    String? providerToken,
    String? providerRefreshToken,
    String? accountId,
    String? userId,
    DateTime? expiresIn,
    DateTime? subExpires,
    DateTime? lastUpdated,
    AccountState? state,
    UserAccount? user,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
