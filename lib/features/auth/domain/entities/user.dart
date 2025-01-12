// lib/features/auth/domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String fullName;
  final String email;
  final String? token; // Optional token field (since not every user may have it)

  const User({
    required this.id,
    required this.name,
    required this.fullName,
    required this.email,
    this.token, // Make token optional
  });

  @override
  List<Object?> get props => [id, name, fullName, email, token];
}
