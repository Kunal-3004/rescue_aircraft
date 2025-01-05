import '../services/auth_services.dart';

class AuthRepository {
  final AuthService authService = AuthService();

  Future<bool> registerUser(String name, String email, String password) async {
    return await authService.registerUser(name, email, password);
  }
}
