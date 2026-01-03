import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../helper/token_storage.dart';
import '../models/reminder.dart';


class ReminderService {
  static final String _baseUrl = dotenv.env['BASE_URL']!;

  static Future<void> createReminder({
    required String eventId,
    required DateTime remindAt,
  }) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse("$_baseUrl/api/reminders"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "event": eventId,
        "remindAt": remindAt.toIso8601String(),
        "method": "notification",
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Tạo reminder thất bại");
    }
  }

  static Future<List<Reminder>> getMyReminders() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse("$_baseUrl/api/reminders"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Reminder.fromJson(e)).toList();
    } else {
      throw Exception("Không tải được reminder");
    }
  }

  static Future<void> deleteReminder(String id) async {
    final token = await TokenStorage.getToken();

    final response = await http.delete(
      Uri.parse("$_baseUrl/api/reminders/$id"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Xóa reminder thất bại");
    }
  }
}
