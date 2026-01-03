import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../helper/token_storage.dart';
import '../models/user.dart';

class UserService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  static Future<List<User>> getAssignableUsers() async {
    final token = await TokenStorage.getToken();

    final url = Uri.parse("$_baseUrl/api/users/assignable");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception(
        "Không tải được danh sách user (${response.statusCode})",
      );
    }
  }
}
