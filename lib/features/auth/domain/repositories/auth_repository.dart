// lib/features/auth/domain/repositories/auth_repository.dart
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  /// Attempts to sign in a user with email and password
  /// Returns Either a Failure or a User entity
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Registers a new user with the provided details
  /// Returns Either a Failure or the created User entity
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String fullName,
    required String password,
  });

  /// Checks if a user is currently authenticated
  /// Returns true if user is authenticated, false otherwise
  Future<Either<Failure,bool>> isAuthenticated();

  /// Signs out the current user
  /// Returns Either a Failure or Unit (success)
  Future<Either<Failure, Unit>> logout();

  /// Retrieves the currently authenticated user
/// Returns Either a Failure or the User entity
  Future<Either<Failure, User>> getCurrentUser();

}