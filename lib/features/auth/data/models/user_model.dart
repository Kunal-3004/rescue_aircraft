// lib/features/auth/data/models/user_model.dart

import '../../domain/entities/user.dart';

class UserModel extends User {
  final String id;
  final String userName;
  final String fullName;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.token,
    required String name,  // explicitly declare the 'name' parameter here
  }) : super(name: name, id: id, fullName: fullName, email: email);  // pass all required parameters to the superclass constructor

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      userName: json['userName'],
      fullName: json['fullName'],
      email: json['email'],
      token: json['token'],
      name: json['name'],  // Pass the 'name' value to the constructor
    );
  }

  // Convert UserModel to User
  User toEntity() {
    return User(
      id: id,         // Pass 'id' to the User constructor
      name: name,     // Pass 'name' to the User constructor
      fullName: fullName, // Pass 'fullName' to the User constructor
      email: email,   // Pass 'email' to the User constructor
    );
  }
}
