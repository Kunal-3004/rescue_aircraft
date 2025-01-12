import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRemoteDataSource(this._apiClient, this._authLocalDataSource);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.loginEndpoint,
        {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract and securely store the token
        final token = data['token'];
        if (token != null) {
          await _authLocalDataSource.saveToken(token); // Store token securely
        } else {
          throw ServerException('Authentication token missing in response');
        }

        // Return the UserModel
        return UserModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Login failed';
        throw ServerException(error);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }


  Future<UserModel> register(
      String name,
      String email,
      String fullName,
      String password,
      ) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.registerEndpoint,
        {
          'name': name,
          'email': email,
          'fullName': fullName,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Registration failed';
        throw ServerException(error);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  Future<UserModel> getUser(String token) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.userEndpoint,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'User data not found';
        throw ServerException(error);
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

}
