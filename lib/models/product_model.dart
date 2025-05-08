// models/product_model.dart
class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double? price;
  final String? imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}