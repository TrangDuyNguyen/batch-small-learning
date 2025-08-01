class MapData {
  MapData(this.data);

  /// from json
  factory MapData.fromJson(Map<String, dynamic> json) {
    return MapData(json);
  }
  final Map<String, dynamic> data;

  T? get<T>(String key) {
    return data[key] as T?;
  }
}
