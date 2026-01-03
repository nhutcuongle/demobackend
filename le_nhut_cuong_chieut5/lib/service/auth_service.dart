import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../helper/token_storage.dart';

class AuthService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  /// REGISTER
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$_baseUrl/api/auth/register");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {
        "success": true,
        "message": data["message"],
      };
    } else {
      return {
        "success": false,
        "message": data["message"] ?? "Đăng ký thất bại",
      };
    }
  }

  /// LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$_baseUrl/api/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data["token"];
      final user = data["user"];


      return {
        "success": true,
        "token": token,
        "user": user,
        "message": data["message"],
      };
    }

    else {
      return {
        "success": false,
        "message": data["message"] ?? "Đăng nhập thất bại",
      };
    }
  }
}
