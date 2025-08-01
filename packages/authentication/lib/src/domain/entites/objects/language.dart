enum Lang {
  en('EN', 'English'),
  vi('VI', 'Tiếng Việt');

  final String code;
  final String name;

  const Lang(this.code, this.name);

  factory Lang.fromCode(String? code) {
    return Lang.values.firstWhere(
      (role) => role.code.toLowerCase() == code?.toLowerCase(),
      orElse: () => Lang.vi,
    );
  }

  bool get isVI => this == Lang.vi;

  bool get isEN => this == Lang.en;
}

enum Language { VI, EN, NONE }
