// models/store_model.dart
class StoreModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String type;

  StoreModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['_id'] ?? json['id'] ?? '', // Handle both _id and id possibilities
      name: json['name'] ?? '',
      latitude: (json['latitude'] is num) ? json['latitude'].toDouble() : 0.0,
      longitude: (json['longitude'] is num) ? json['longitude'].toDouble() : 0.0,
      type: json['type'] ?? '',
    );
  }
}