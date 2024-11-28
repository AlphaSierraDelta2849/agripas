import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userTokenKey = 'userToken';

  /// Save the user token
  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTokenKey, token);
  }

  /// Retrieve the user token
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTokenKey);
  }

  /// Remove the user token (logout)
  Future<void> clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userTokenKey);
  }

  /// Check if the user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
