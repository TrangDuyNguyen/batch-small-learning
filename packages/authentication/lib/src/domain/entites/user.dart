import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String accountId,
    String? firstName,
    String? lastName,
    @Default('') String fullName,
    @Default('') String email,
    DateTime? lastLoginAt,
    String? avatar,
    String? cover,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? deletedAt,
    String? createdBy,
    String? lastUpdatedBy,
    String? deletedBy,
    String? bsc,
    Map<String, dynamic>? metadata,
  }) = _UserProfile;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
