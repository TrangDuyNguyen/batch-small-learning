import 'dart:convert';

import '../../../../authentication_module.dart';
import '../datasource_module.dart';

extension LoginResMapper on LoginRes {
  AuthSession toDomain() {
    final isGuest = role == 0;
    return AuthSession(
      accessToken: isGuest ? null : accessToken,
      refreshToken: isGuest ? null : refreshToken,
      publicToken: isGuest ? accessToken : null,
      publicRefreshToken: isGuest ? refreshToken : null,
      userId: uid,
      state: AccountState.fromInt(state ?? 0),
      subExpires: DateTime.tryParse(subExpires ?? ''),
      lastUpdated: DateTime.now(),
      user: UserAccount(
        id: UniqueId.generateUuid(),
        userid: uid,
        identifier: email,
        avatar: avatar,
        profile: User(
          id: UniqueId.generateUuid(),
          accountId: uid ?? UniqueId.generateUuid(),
          firstName: firstName,
          lastName: lastName,
          fullName: '${firstName ?? ''} ${lastName ?? ''}'.trim(),
          email: email ?? '',
          avatar: avatar,
          cover: cover,
        ),
        categories: categories,
      ),
    );
  }
}

Map<String, dynamic>? parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    return null;
  }

  try {
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));

    return json.decode(decoded);
  } catch (e) {
    return null;
  }
}

extension AuthSessionMapper on String {
  AuthSession toAuthSession() {
    final Map<String, dynamic>? payload = parseJwt(this);
    if (payload == null) {
      throw Exception('JWT payload is null or invalid.');
    }

    final userId = payload['uid'] as String?;
    final email = payload['email'] as String?;
    final state =
        payload['state'] is int
            ? payload['state'] as int
            : int.tryParse(payload['state']?.toString() ?? '') ?? 0;
    final subExpiresStr = payload['subExpires'] as String?;
    final exp =
        payload['exp'] is int
            ? payload['exp'] as int
            : int.tryParse(payload['exp']?.toString() ?? '');

    final firstName = payload['firstName'] as String? ?? '';
    final lastName = payload['lastName'] as String? ?? '';
    final avatar = payload['avatar'] as String?;
    final cover = payload['cover'] as String?;

    final categoriesRaw = payload['categories'];
    final categories =
        (categoriesRaw is List)
            ? categoriesRaw
                .map((e) => int.tryParse(e.toString()))
                .whereType<int>()
                .toList()
            : null;

    return AuthSession(
      accessToken: this,
      refreshToken: null,
      publicToken: null,
      publicRefreshToken: null,
      userId: userId,
      state: AccountState.fromInt(state),
      lastUpdated: DateTime.now(),
      subExpires: DateTime.tryParse(subExpiresStr ?? ''),
      expiresIn:
          exp != null ? DateTime.fromMillisecondsSinceEpoch(exp * 1000) : null,
      user: UserAccount(
        id: UniqueId.generateUuid(),
        userid: userId,
        identifier: email,
        avatar: avatar,
        profile: User(
          id: UniqueId.generateUuid(),
          accountId: userId ?? UniqueId.generateUuid(),
          firstName: firstName,
          lastName: lastName,
          fullName: '$firstName $lastName'.trim(),
          email: email ?? '',
          avatar: avatar,
          cover: cover,
        ),
        categories: categories,
      ),
    );
  }
}
