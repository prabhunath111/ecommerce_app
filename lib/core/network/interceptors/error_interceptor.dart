import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

/// Error interceptor that catches DioExceptions and converts them to domain-level exceptions
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        exception = const NetworkException(
          message: 'Connection timed out. Please check your internet connection.',
        );
        break;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final responseData = err.response?.data;
        String errorMessage = 'Server encountered an error ($statusCode)';

        if (responseData is Map && responseData.containsKey('message')) {
          errorMessage = responseData['message'].toString();
        } else if (responseData is String && responseData.isNotEmpty) {
          errorMessage = responseData;
        }

        if (statusCode == 401 || statusCode == 403) {
          exception = AuthException(
            message: errorMessage.isNotEmpty ? errorMessage : 'Unauthorized access. Please log in again.',
            statusCode: statusCode,
          );
        } else {
          exception = ServerException(
            message: errorMessage,
            statusCode: statusCode,
          );
        }
        break;

      case DioExceptionType.cancel:
        exception = const ServerException(message: 'Request was cancelled.');
        break;

      default:
        exception = ServerException(
          message: err.message ?? 'An unexpected network error occurred.',
        );
    }

    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }
}
