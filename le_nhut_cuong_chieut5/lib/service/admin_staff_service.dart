import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../helper/token_storage.dart';
import '../models/AdminUser.dart';

class AdminStaffService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  static Future<Map<String, String>> _authHeader() async {
    final token = await TokenStorage.getToken();
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  /// GET ALL STAFF
  static Future<List<AdminUser>> getAllStaff() async {
    final res = await http.get(
      Uri.parse("$_baseUrl/api/admin/staff"),
      headers: await _authHeader(),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => AdminUser.fromJson(e)).toList();
    } else {
      throw Exception("Không thể lấy danh sách staff");
    }
  }

  /// CREATE STAFF
  static Future<void> createStaff({
    required String username,
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse("$_baseUrl/api/admin/staff"),
      headers: await _authHeader(),
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode != 201) {
      final msg = jsonDecode(res.body)["message"] ?? "Tạo staff thất bại";
      throw Exception(msg);
    }
  }

  /// UPDATE STAFF
  static Future<void> updateStaff({
    required String id,
    String? username,
    String? email,
    String? password,
    bool? isDisabled,
  }) async {
    final body = <String, dynamic>{};
    if (username != null) body["username"] = username;
    if (email != null) body["email"] = email;
    if (password != null) body["password"] = password;
    if (isDisabled != null) body["isDisabled"] = isDisabled;

    final res = await http.put(
      Uri.parse("$_baseUrl/api/admin/staff/$id"),
      headers: await _authHeader(),
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception("Cập nhật staff thất bại");
    }
  }

  /// DELETE STAFF
  static Future<void> deleteStaff(String id) async {
    final res = await http.delete(
      Uri.parse("$_baseUrl/api/admin/staff/$id"),
      headers: await _authHeader(),
    );

    if (res.statusCode != 200) {
      throw Exception("Xóa staff thất bại");
    }
  }
}
