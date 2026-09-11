import "package:dartz/dartz.dart";
import "package:frontend/core/error/failures.dart";

// ignore: avoid_types_as_parameter_names
abstract class Usecase <Type,Params>{
  Future<Either<Failure,Type>>call({required Params params});
}

class NoParams{}