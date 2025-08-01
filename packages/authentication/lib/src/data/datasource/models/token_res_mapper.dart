import '../../../../authentication_module.dart';
import '../datasource_module.dart';

extension TokenResMapper on TokenRes {
  AuthSession toDomain() {
    if (this.user != null && this.user!.isAnonymous == true) {
      return AuthSession(
        publicRefreshToken: refreshToken,
        publicToken: accessToken,

        // Không thể map trực tiếp các trường sau - phải suy luận hoặc cần trường bổ sung:
        // - publicToken: Không có trong TokenRes
        // - accountId: Không có trong TokenRes, có thể lấy từ user.id hoặc metadata
        // - userId: Có thể lấy từ user.id
        userId: user?.id,
        // Chuyển đổi expiresIn từ seconds sang DateTime
        expiresIn:
            expiresAt != null
                ? DateTime.fromMillisecondsSinceEpoch(expiresAt! * 1000)
                : null,
        // Tạo lastUpdated là thời điểm hiện tại khi chuyển đổi
        lastUpdated: DateTime.now(),
        user: UserAccount(
          id: UniqueId.generateUuid(),
          identifier: this.user?.email,
        ),
      );
    }
    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      // Không thể map trực tiếp các trường sau - phải suy luận hoặc cần trường bổ sung:
      // - publicToken: Không có trong TokenRes
      // - accountId: Không có trong TokenRes, có thể lấy từ user.id hoặc metadata
      // - userId: Có thể lấy từ user.id
      userId: user?.id,
      // Chuyển đổi expiresIn từ seconds sang DateTime
      expiresIn:
          expiresAt != null
              ? DateTime.fromMillisecondsSinceEpoch(expiresAt! * 1000)
              : null,
      // Tạo lastUpdated là thời điểm hiện tại khi chuyển đổi
      lastUpdated: DateTime.now(),
      user: UserAccount(
        id: UniqueId.generateUuid(),
        identifier: this.user?.email,
      ),
    );
  }
}
