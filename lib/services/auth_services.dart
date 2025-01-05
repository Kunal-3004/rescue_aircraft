import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rescue_aircraft/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> loginUser(String email, String password) async {
    final url = Uri.parse(Utils.loginUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final sharedPreferences = await SharedPreferences.getInstance();

        sharedPreferences.setString('token', data['token']);
        sharedPreferences.setBool('isLoggedIn', true);

        return true;
      } else {
        final error = jsonDecode(response.body)['error'];
        throw Exception(error ?? "Login failed.");
      }
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }
  }
  
  Future<bool> registerUser(String name, String email, String password) async {
    final url = Uri.parse(Utils.registrationUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Registration failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Something went wrong. Please try again.");
    }
  }
}
