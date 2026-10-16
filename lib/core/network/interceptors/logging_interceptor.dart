import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Clean logging interceptor for inspecting HTTP requests, responses, and errors
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--> [HTTP REQUEST] ${options.method} ${options.uri}');
      if (options.data != null) {
        debugPrint('    Payload: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- [HTTP RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('<-- [HTTP ERROR] ${err.type} [${err.response?.statusCode}] ${err.requestOptions.uri}');
      debugPrint('    Message: ${err.message}');
    }
    super.onError(err, handler);
  }
}
