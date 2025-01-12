import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../../core/errors/exceptions.dart';


class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource, this._authLocalDataSource);

  @override
  Future<Either<Failure, User>> login({required String email, required String password}) async {
    try {
      // Call the remote data source to log in
      final userModel = await _authRemoteDataSource.login(email, password);

      // Save the token locally
      await _authLocalDataSource.saveToken(userModel.token);
      await _authLocalDataSource.setLoggedIn(true);

      // Return user entity
      return Right(User(
        id: userModel.id,
        name: userModel.userName,
        fullName: userModel.fullName,
        email: userModel.email,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
      required String name,
      required String email,
      required String fullName,
      required String password,
}) async {
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty || fullName.isEmpty) {
        return Left(ValidationFailure('All fields are required'));
      }

      if (!email.contains('@')) {
        return Left(ValidationFailure('Invalid email format'));
      }

      final userModel = await _authRemoteDataSource.register(
        name,
        email,
        fullName,
        password,
      );

      final user = User(
        id: userModel.id,
        name: userModel.userName,
        fullName: userModel.fullName,
        email: userModel.email,
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    return Right(await _authLocalDataSource.isLoggedIn());
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    await _authLocalDataSource.clearToken();
    await _authLocalDataSource.setLoggedIn(false);
    return Right(unit); // Return Unit to indicate successful logout
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final token = await _authLocalDataSource.getToken();
      final userModel = await _authRemoteDataSource.getUser(token!);

      return Right(User(
        id: userModel.id,
        name: userModel.userName,
        fullName: userModel.fullName,
        email: userModel.email,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}