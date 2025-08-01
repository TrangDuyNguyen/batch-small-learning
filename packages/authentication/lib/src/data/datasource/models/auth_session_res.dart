import '../datasource_module.dart';

class AuthSessionRes {
  AuthSessionRes({this.user, this.session});

  factory AuthSessionRes.fromJson(Map<String, dynamic> json) {
    return AuthSessionRes(
      user: json['user'] != null ? UserRes.fromJson(json['user']) : null,
      session:
          json['session'] != null ? TokenRes.fromJson(json['session']) : null,
    );
  }

  final UserRes? user;
  final TokenRes? session;

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson(), 'session': session?.toJson()};
  }
}
