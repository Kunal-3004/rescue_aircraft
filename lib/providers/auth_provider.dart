import 'package:flutter/material.dart';
import '../domain/user_register.dart';
import '../services/auth_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final RegisterUser registerUserUseCase;

  AuthProvider({required this.registerUserUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      bool isSuccess = await _authService.loginUser(email, password);

      if (isSuccess) {
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid login credentials';
        Fluttertoast.showToast(msg: _errorMessage);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      Fluttertoast.showToast(msg: _errorMessage);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      bool isSuccess = await registerUserUseCase.execute(name, email, password);
      if (isSuccess) {
        Fluttertoast.showToast(msg: 'Registration successful');
      } else {
        Fluttertoast.showToast(msg: 'Registration failed');
      }
      return isSuccess;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
