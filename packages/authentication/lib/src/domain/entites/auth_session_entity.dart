import '../../../authentication_module.dart';

class AuthSessionEntity {
  final User? user;
  final AuthSession? session;

  AuthSessionEntity({this.user, this.session});
}
