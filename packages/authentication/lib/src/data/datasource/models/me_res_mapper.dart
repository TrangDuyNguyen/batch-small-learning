import '../../../../authentication_module.dart';
import '../datasource_module.dart';

extension MeResMapper on MeRes {
  UserAccount toDomain() {
    return UserAccount(
      id: UniqueId.generateUuid(),
      userid: uid,
      identifier: email,
      avatar: avatar,
      profile: User(
        id: UniqueId.generateUuid(),
        email: email ?? '',
        firstName: firstName,
        lastName: lastName,
        fullName:
            firstName != null && lastName != null ? '$firstName $lastName' : '',
        avatar: avatar,
        cover: cover,
        accountId: uid ?? '',
        bsc: bsc,
      ),
      status: AccountStatus.active,
      lastUpdated: null,
      lastLoginAt: null,
      categories: categories,
      permission: permission,
    );
  }
}
