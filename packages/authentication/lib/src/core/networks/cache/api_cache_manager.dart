abstract class ApiCacheManager {
  Future<void> set(String key, value);
  Future<dynamic> get(String key);
}
