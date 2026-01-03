  // import 'dart:convert';
  // import 'package:http/http.dart' as http;
  // import 'package:flutter_dotenv/flutter_dotenv.dart';
  // import '../helper/token_storage.dart';
  // import '../models/event.dart';
  //
  // class EventService {
  //   static final String _baseUrl = dotenv.env['BASE_URL']!;
  //
  //   static Future<List<Event>> getMyEvents() async {
  //     final token = await TokenStorage.getToken();
  //
  //     final response = await http.get(
  //       Uri.parse("$_baseUrl/api/events"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List data = jsonDecode(response.body);
  //       return data.map((e) => Event.fromJson(e)).toList();
  //     } else {
  //       throw Exception("Không tải được sự kiện");
  //     }
  //   }
  //
  //   static Future<void> createEvent(Map<String, dynamic> body) async {
  //     final token = await TokenStorage.getToken();
  //
  //     final response = await http.post(
  //       Uri.parse("$_baseUrl/api/events"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode(body),
  //     );
  //
  //     if (response.statusCode != 201) {
  //       throw Exception("Tạo sự kiện thất bại");
  //     }
  //   }
  //
  //   static Future<void> deleteEvent(String id) async {
  //     final token = await TokenStorage.getToken();
  //
  //     await http.delete(
  //       Uri.parse("$_baseUrl/api/events/$id"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //   }
  //   static Future<void> updateEvent(String id, Map<String, dynamic> body) async {
  //     final token = await TokenStorage.getToken();
  //
  //     final response = await http.put(
  //       Uri.parse("$_baseUrl/api/events/$id"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode(body),
  //     );
  //
  //     if (response.statusCode != 200) {
  //       throw Exception("Cập nhật sự kiện thất bại");
  //     }
  //   }
  //   static Future<List<Event>> getAllEvents() async {
  //     final token = await TokenStorage.getToken();
  //
  //     final response = await http.get(
  //       Uri.parse("$_baseUrl/api/events/all"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //
  //     print("STATUS: ${response.statusCode}");
  //     print("BODY: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final List data = jsonDecode(response.body);
  //       return data.map((e) => Event.fromJson(e)).toList();
  //     } else if (response.statusCode == 403) {
  //       throw Exception("Bạn không có quyền STAFF");
  //     } else {
  //       throw Exception("Không tải được danh sách sự kiện");
  //     }
  //   }
  //
  // }



  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  import '../helper/token_storage.dart';
  import '../models/event.dart';

  class EventService {
    static final String _baseUrl = dotenv.env['BASE_URL']!;

    /// ================= USER =================
    /// User chỉ xem sự kiện của mình
    static Future<List<Event>> getMyEvents() async {
      final token = await TokenStorage.getToken();

      final response = await http.get(
        Uri.parse("$_baseUrl/api/events"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Event.fromJson(e)).toList();
      } else {
        throw Exception("Không tải được sự kiện cá nhân");
      }
    }

    /// ================= CREATE EVENT =================
    /// - User: tạo cho chính mình
    /// - Staff: tạo cho user khác (truyền owner)
    static Future<void> createEvent({
      required String title,
      required DateTime startTime,
      required DateTime endTime,
      String? description,
      String? ownerId, // chỉ staff dùng
    }) async {
      final token = await TokenStorage.getToken();

      final body = {
        "title": title,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
      };

      if (description != null) body["description"] = description;
      if (ownerId != null) body["owner"] = ownerId;

      final response = await http.post(
        Uri.parse("$_baseUrl/api/events"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 201) {
        throw Exception("Tạo sự kiện thất bại");
      }
    }

    /// ================= STAFF / ADMIN =================
    /// Xem tất cả sự kiện
    static Future<List<Event>> getAllEvents() async {
      final token = await TokenStorage.getToken();

      final response = await http.get(
        Uri.parse("$_baseUrl/api/events/all"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Event.fromJson(e)).toList();
      } else if (response.statusCode == 403) {
        throw Exception("Bạn không có quyền STAFF");
      } else {
        throw Exception("Không tải được danh sách sự kiện");
      }
    }

    /// ================= STAFF =================
    /// Chỉ sửa sự kiện do mình tạo
    static Future<void> updateEvent(
        String eventId,
        Map<String, dynamic> body,
        ) async {
      final token = await TokenStorage.getToken();

      final response = await http.put(
        Uri.parse("$_baseUrl/api/events/$eventId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception("Không có quyền chỉnh sửa sự kiện");
      }
    }

    /// ================= STAFF =================
    /// Chỉ xóa sự kiện do mình tạo
    static Future<void> deleteEvent(String eventId) async {
      final token = await TokenStorage.getToken();

      final response = await http.delete(
        Uri.parse("$_baseUrl/api/events/$eventId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Không có quyền xóa sự kiện");
      }
    }

    /// ================= ADMIN =================
    /// Ẩn sự kiện
    static Future<void> hideEvent(String eventId) async {
      final token = await TokenStorage.getToken();

      final response = await http.put(
        Uri.parse("$_baseUrl/api/events/$eventId/hide"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Ẩn sự kiện thất bại");
      }
    }
  }
