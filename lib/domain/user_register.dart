import '../repositories/auth_repo.dart';

class RegisterUser {
  final AuthRepository authRepository;

  RegisterUser({required this.authRepository});

  Future<bool> execute(String name, String email, String password) async {
    return await authRepository.registerUser(name, email, password);
  }
}
