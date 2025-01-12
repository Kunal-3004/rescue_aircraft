
// lib/features/auth/domain/usecases/sign_in_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../../core/usecases/empty_params.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInParams extends EmptyParams {
  final String email;
  final String password;

  SignInParams({required this.email, required this.password});
}

class SignInUseCase implements UseCases<User, SignInParams> {
  final AuthRepository authRepository;

  SignInUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    // 1. Input Validation (Optional but Recommended)
    if (params.email.isEmpty || params.password.isEmpty) {
      return Left(ValidationFailure('Email and password are required.')); // Use ValidationFailure
    }

    if (!params.email.contains('@')) {
      return Left(ValidationFailure('Invalid email format.')); // Use ValidationFailure
    }

    // 2. Call the Repository
    final result = await authRepository.login(
      email: params.email,
      password: params.password,
    );

    // 3. Handle Repository Result and Map to Use Case Failure (if needed)
    return result.fold(
          (failure) {
        // Map repository failures to more specific use case failures if needed
        if (failure is ServerFailure) {
          return Left(AuthFailure('Server error during login.'));
        } else if (failure is ValidationFailure) {
          return Left(AuthFailure('Validation error during login.'));
        } else {
          return Left(AuthFailure(failure.message)); // Default to the original failure message
        }
      },
          (user) => Right(user),
    );
  }
}
