import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthStorage {
  static const String _keyUser = 'user_data';
  static const String _keyToken = 'auth_token';

  /// Save user data dan token ke local storage
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
    if (user.token != null) {
      await prefs.setString(_keyToken, user.token!);
    }
  }

  /// Get user data dari local storage
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  /// Get token dari local storage
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Clear user data dan token (untuk logout)
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    await prefs.remove(_keyToken);
  }

  /// Check apakah user sudah login
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}
