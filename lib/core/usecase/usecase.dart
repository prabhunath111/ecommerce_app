import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Abstract base contract for all use cases (OOP Abstraction)
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Helper class for use cases that do not require any input parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
