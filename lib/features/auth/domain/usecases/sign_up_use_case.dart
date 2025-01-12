// lib/features/auth/domain/usecases/sign_up_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../../core/usecases/empty_params.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class SignUpParams extends EmptyParams {
  final String name;
  final String email;
  final String fullName;
  final String password;

  SignUpParams({
    required this.name,
    required this.email,
    required this.fullName,
    required this.password,
  });
}

class SignUpUseCase implements UseCases<User, SignUpParams> {
  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    // 1. Input Validation (Optional but Recommended)
    if (params.name.isEmpty ||
        params.email.isEmpty ||
        params.fullName.isEmpty ||
        params.password.isEmpty) {
      return Left(ValidationFailure('All fields are required.'));
    }

    if (!params.email.contains('@')) {
      return Left(ValidationFailure('Invalid email format.'));
    }

    // 2. Call the Repository
    final result = await authRepository.register(
      name: params.name,
      email: params.email,
      fullName: params.fullName,
      password: params.password,
    );

    // 3. Handle Repository Result and Map to Use Case Failure (if needed)
    return result.fold(
          (failure) {
        // Map repository failures to more specific use case failures if needed
        if (failure is ServerFailure) {
          return Left(AuthFailure('Server error during registration.'));
        } else if (failure is ValidationFailure) {
          return Left(AuthFailure('Validation error during registration.'));
        } else {
          return Left(AuthFailure(failure.message)); // Default to the original failure message
        }
      },
          (user) => Right(user),
    );
  }
}