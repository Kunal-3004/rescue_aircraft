// lib/features/auth/domain/usecases/sign_out_use_case.dart
import 'package:dartz/dartz.dart';
import 'package:rescue_aircraft/core/usecases/empty_params.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase implements UseCases<Unit, EmptyParams> {
  final AuthRepository authRepository;

  SignOutUseCase(this.authRepository);

  Future<Either<Failure, Unit>> call(EmptyParams params) async {
    final result = await authRepository.logout();
    return result.fold(
          (failure) => Left(AuthFailure(failure.message)),
          (unit) => Right(unit),
    );
  }
}