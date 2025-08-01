enum AccountState {
  unactive(0),
  active(1),
  banned(2),
  deleted(3),
  softDelete(4),
  verified(5);

  final int value;
  const AccountState(this.value);

  /// Chuyển đổi từ `int` sang `UserState`
  static AccountState fromInt(int value) {
    return AccountState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AccountState.unactive,
    );
  }
  
  @override
  String toString() {
    return name.toUpperCase();
  }
}
