import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../helper/token_storage.dart';
import '../models/AdminUser.dart';


class AdminUserService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  /// GET ALL USERS
  static Future<List<AdminUser>> getAllUsers() async {
    final token = await TokenStorage.getToken();

    final res = await http.get(
      Uri.parse("$_baseUrl/api/users"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => AdminUser.fromJson(e)).toList();
    } else {
      throw Exception("Không thể lấy danh sách user");
    }
  }
  /// DELETE USER (ADMIN)
  static Future<void> deleteUser(String id) async {
    final token = await TokenStorage.getToken();

    final res = await http.delete(
      Uri.parse("$_baseUrl/api/users/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Xóa user thất bại");
    }
  }

  /// DISABLE USER
  static Future<void> disableUser(String id) async {
    final token = await TokenStorage.getToken();

    await http.put(
      Uri.parse("$_baseUrl/api/users/$id/disable"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }

  /// ENABLE USER
  static Future<void> enableUser(String id) async {
    final token = await TokenStorage.getToken();

    await http.put(
      Uri.parse("$_baseUrl/api/users/$id/enable"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
  }
}
