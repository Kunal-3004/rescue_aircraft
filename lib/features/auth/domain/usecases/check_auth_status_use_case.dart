// lib/features/auth/domain/usecases/check_auth_status_use_case.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository authRepository;

  CheckAuthStatusUseCase(this.authRepository);

  Future<Either<Failure, bool>> call() async {
    final result = await authRepository.isAuthenticated(); // Get the Either<Failure, bool>

    return result.fold(
          (failure) {
        // Map any Failure to AuthFailure
        return Left(AuthFailure(failure.message));
      },
          (isAuthenticated) {
        return Right(isAuthenticated);
      },
    );
  }
}