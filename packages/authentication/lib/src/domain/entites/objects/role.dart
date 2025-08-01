// user_role.dart
@Deprecated("chuyen qua UserRole")
enum Role {
  GUEST,
  USER,
  ADMIN;

  const Role();

  bool get isGuest => this == Role.GUEST;

  bool get isRegular => this == Role.USER;

  bool get isAdmin => this == Role.ADMIN;

  static Role fromString(String role) {
    switch (role) {
      case 'GUEST':
        return Role.GUEST;
      case 'USER':
        return Role.USER;
      case 'ADMIN':
        return Role.ADMIN;
      default:
        throw ArgumentError('Unknown role: $role');
    }
  }

  String toString() {
    switch (this) {
      case Role.GUEST:
        return 'GUEST';
      case Role.USER:
        return 'USER';
      case Role.ADMIN:
        return 'ADMIN';
    }
  }
}
