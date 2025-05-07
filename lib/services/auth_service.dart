import 'dart:convert';
import '../constants/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  Future<void> register(UserModel user) async {
    final response = await http.post(
      Uri.parse("$authUrl/signup"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw ("${body['message'] ?? response.body}");
    }
  }

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$authUrl/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['token'];
    } else {
      final body = jsonDecode(response.body);
      throw ("${body['message'] ?? response.body}");
    }
  }

}
