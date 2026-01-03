import 'package:jwt_decode/jwt_decode.dart';
import 'token_storage.dart';

class AuthHelper {
  static Future<String?> getUserRole() async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    final payload = Jwt.parseJwt(token);
    return payload['role'];
  }

  static Future<String?> getUserId() async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    final payload = Jwt.parseJwt(token);
    return payload['id'];
  }
}
