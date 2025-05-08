// models/product_model.dart
class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final ProductPhoto? productPhoto;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.productPhoto,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble(),
      productPhoto: json['productPhoto'] != null
          ? ProductPhoto.fromJson(json['productPhoto'])
          : null,
    );
  }
}

class ProductPhoto {
  final String url;
  final String publicId;

  ProductPhoto({
    required this.url,
    required this.publicId,
  });

  factory ProductPhoto.fromJson(Map<String, dynamic> json) {
    return ProductPhoto(
      url: json['url'],
      publicId: json['publicId'],
    );
  }
}