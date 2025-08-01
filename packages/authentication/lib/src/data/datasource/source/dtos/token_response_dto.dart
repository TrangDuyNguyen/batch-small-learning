
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../authentication_module.dart';

part 'token_response_dto.freezed.dart';

part 'token_response_dto.g.dart';

enum TokenStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('INACTIVE')
  inactive,
  @JsonValue('REVOKED')
  revoked,
  @JsonValue('DELETED')
  deleted,
  @JsonValue('LOCKED')
  locked,
}

enum RoleDto {
  @JsonValue('GUEST')
  GUEST,
  @JsonValue('USER')
  USER,
  @JsonValue('ADMIN')
  ADMIN,
}

@Freezed()
class TokenResponseDto with _$TokenResponseDto {
  factory TokenResponseDto({
    required String accessToken,
    String? refreshToken,
    required String type,
    String? userId,
    int? expireIn,
    String? clientId,
    String? accountId,
    TokenStatus? status,
    List<RoleDto>? roles,
  }) = _TokenResponseDto;

  factory TokenResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseDtoFromJson(json);
}

extension TokenResponseDtoX on TokenResponseDto {
  AuthSession toDomain() => AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
        accountId: accountId ?? '',
        userId: userId ?? '',
        expiresIn: expireIn != null
            ? DateTime.now().add(Duration(seconds: expireIn!))
            : null,
        lastUpdated: DateTime.now(),
      );
}
