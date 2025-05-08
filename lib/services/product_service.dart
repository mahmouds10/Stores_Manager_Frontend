// services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';
import '../models/product_model.dart';

class ProductService {
  Future<List<ProductModel>> getAllProducts() async {
    final response = await http.get(
      Uri.parse("$productsUrl/get-products"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final List<dynamic> productsList = responseData['products'];

      return productsList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      final body = jsonDecode(response.body);
      throw ("${body['message'] ?? response.body}");
    }
  }

  Future<List<ProductModel>> getProductsForStore(String storeId) async {
    final response = await http.get(
      Uri.parse("$productsUrl/products-per-store/$storeId"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      final List<dynamic> productsList = responseData['products'];

      return productsList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      final body = jsonDecode(response.body);
      throw ("${body['message'] ?? response.body}");
    }
  }
}