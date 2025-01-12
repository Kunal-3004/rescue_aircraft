

import 'package:dartz/dartz.dart';
import 'package:rescue_aircraft/core/errors/failures.dart';
import 'package:rescue_aircraft/core/usecases/empty_params.dart';
import 'package:rescue_aircraft/core/usecases/usecases.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCases<User, EmptyParams> {
  final AuthRepository authRepository;

  GetCurrentUserUseCase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(EmptyParams params) async {
    final res = await authRepository.getCurrentUser();

    return res.fold(
        (failure) => Left(failure),
        (user) => Right(user)
    );
  }
}