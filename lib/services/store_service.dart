// services/store_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_config.dart';
import '../models/store_model.dart';

class StoreService {
  Future<List<StoreModel>> getAllStores() async {
    final response = await http.get(
      Uri.parse("$storesUrl/get-all-stores"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // 1. Decode into a Map
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // 2. Extract the 'data' field (which is a List)
      final List<dynamic> storesList = responseData['data'];

      // 3. Map each item to StoreModel
      return storesList.map((json) => StoreModel.fromJson(json)).toList();
    } else {
      final body = jsonDecode(response.body);
      throw ("${body['message'] ?? response.body}");
    }
  }

  Future<List<StoreModel>> getStoresForProduct(String productId) async {
    final response = await http.get(
      Uri.parse("$storesUrl/stores-for-product/$productId"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Same fix here
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> storesList = responseData['stores'];
      return storesList.map((json) => StoreModel.fromJson(json)).toList();
    } else {
      final body = jsonDecode(response.body);
      throw ("${body['message'] ?? response.body}");
    }
  }
}