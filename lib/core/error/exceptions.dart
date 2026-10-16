/// Base exception class for all data-layer exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => '$runtimeType: $message (code: $statusCode)';
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}

class AuthException extends AppException {
  const AuthException({required super.message, super.statusCode});
}

class CacheException extends AppException {
  const CacheException({required super.message, super.statusCode});
}

class PaymentException extends AppException {
  const PaymentException({required super.message, super.statusCode});
}
