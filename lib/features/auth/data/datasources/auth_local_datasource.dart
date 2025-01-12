// lib/features/auth/data/datasources/auth_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSource(this._sharedPreferences);

  // Save token
  Future<void> saveToken(String token) async {
    await _sharedPreferences.setString('authToken', token);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return _sharedPreferences.getString('authToken');
  }

  // Clear token
  Future<void> clearToken() async {
    await _sharedPreferences.remove('authToken');
  }

  // Save login state
  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _sharedPreferences.setBool('isLoggedIn', isLoggedIn);
  }

  // Retrieve login state
  Future<bool> isLoggedIn() async {
    return _sharedPreferences.getBool('isLoggedIn') ?? false;
  }
}
