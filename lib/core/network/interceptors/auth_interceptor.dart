import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../../services/storage_service.dart';

/// Interceptor to automatically attach JWT or Bearer token to headers
class AuthInterceptor extends Interceptor {
  final StorageService storageService;

  AuthInterceptor({required this.storageService});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = storageService.getString(AppConstants.authTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    return handler.next(options);
  }
}
