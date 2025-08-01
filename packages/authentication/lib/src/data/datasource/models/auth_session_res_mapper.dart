import '../../../../authentication_module.dart';
import 'token_res_mapper.dart';
import 'auth_session_res.dart';

extension AuthSessionResMapper on AuthSessionRes {
  AuthSessionEntity toDomain() {
    return AuthSessionEntity(
      session: session?.toDomain(),
    );
  }
}
