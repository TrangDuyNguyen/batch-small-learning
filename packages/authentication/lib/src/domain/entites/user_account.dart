import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../authentication_module.dart';
import '../../core/utils/generate_uuid.dart';

part 'user_account.freezed.dart';
part 'user_account.g.dart';

@freezed
class UserAccount with _$UserAccount {
  const factory UserAccount({
    required String id,
    String? userid,
    String? identifier,
    String? avatar,
    Map<String, String>? deviceInfo,
    @Default(AccountStatus.active) AccountStatus status,
    DateTime? lastUpdated,
    DateTime? lastLoginAt,
    List<int>? categories,
    List<int>? permission,
    User? profile,
  }) = _UserAccount;

  factory UserAccount.fromJson(Map<String, dynamic> json) =>
      _$UserAccountFromJson(json);
}

enum UserPermission {
  none(null),
  member(0),
  event(1);

  final int? v;
  const UserPermission(this.v);
  static UserPermission fromInt(int? v) {
    return UserPermission.values.firstWhere(
      (e) => e.v == v,
      orElse: () => UserPermission.none,
    );
  }

  static bool isEventCreator(List<int>? permission) {
    return permission?.contains(1) ?? false;
  }
}

class AccountFactory {
  AccountFactory._();

  static UserAccount create({
    required User profile,
    String? accountId,
    String? userid,
    AccountStatus status = AccountStatus.active,
    DateTime? lastUpdated,
    DateTime? lastLoginAt,
    List<int>? permission,
  }) {
    return UserAccount(
      id: UniqueId.generateUuid(),
      userid: userid,
      status: status,
      lastUpdated: lastUpdated,
      lastLoginAt: lastLoginAt,
      permission: permission,
    );
  }
}

// Enum để quản lý trạng thái account
enum AccountStatus { active, inactive, suspended, deleted }
