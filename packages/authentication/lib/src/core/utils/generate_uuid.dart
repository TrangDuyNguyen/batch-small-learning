import 'package:uuid/uuid.dart';

class UniqueId {
  UniqueId._();
  static const Uuid _uuid = Uuid();

  static String local = 'local';

  static bool isLocal(String id) {
    return id.startsWith(local);
  }

  /// Generate a unique ID (v4)
  static String generateId({String? prefix = 'local'}) {
    if (prefix != null) {
      return '$prefix-${_uuid.v4()}';
    }
    return _uuid.v4();
  }

  static String generateUuid() {
    return _uuid.v4();
  }

  static String generateTimestamp() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
