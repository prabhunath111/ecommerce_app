import 'package:equatable/equatable.dart';

/// Base failure class representing domain layer errors
abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to load cached data.',
    super.code,
  });
}

class PaymentFailure extends Failure {
  const PaymentFailure({required super.message, super.code});
}
