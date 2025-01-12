import 'package:dartz/dartz.dart';
import 'package:rescue_aircraft/core/errors/failures.dart';

abstract class UseCases<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}