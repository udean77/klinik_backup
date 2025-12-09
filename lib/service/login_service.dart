import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/user_info.dart';

/// LoginService can either use a MockAPI endpoint (provide baseUrl)
/// or fall back to the original hardcoded admin/admin behavior when
/// `baseUrl` is null.
class LoginService {
  final String? baseUrl;

  LoginService({this.baseUrl});

  /// Expected server response (JSON) on success:
  /// {
  ///   "token": "<jwt-or-any-string>",
  ///   "user": { "id": "1", "username": "admin", "role": "pegawai" }
  /// }
  Future<bool> login(String username, String password) async {
    // Fallback: keep the original hardcoded admin/admin for local testing
    if (baseUrl == null) {
      if (username == 'admin' && password == 'admin') {
        await UserInfo().setToken('admin');
        await UserInfo().setUserID('1');
        await UserInfo().setUsername('admin');
        await UserInfo().setUserRole('pegawai');
        return true;
      }
      return false;
    }

    try {
      final uri = Uri.parse('$baseUrl/login');
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (res.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(res.body);
        final token = body['token']?.toString();
        final user = body['user'] as Map<String, dynamic>?;
        if (token != null && user != null) {
          await UserInfo().setToken(token);
          await UserInfo().setUserID(user['id']?.toString() ?? '');
          await UserInfo().setUsername(user['username']?.toString() ?? '');
          await UserInfo().setUserRole(user['role']?.toString() ?? 'pasien');
          return true;
        }
      }
      return false;
    } catch (e) {
      // On network/error, return false so UI can show message
      return false;
    }
  }
}
