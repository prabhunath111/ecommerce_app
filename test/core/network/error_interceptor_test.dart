import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late ErrorInterceptor interceptor;
  late MockErrorInterceptorHandler mockHandler;

  setUpAll(() {
    registerFallbackValue(
      DioException(requestOptions: RequestOptions(path: '/test')),
    );
  });

  setUp(() {
    interceptor = ErrorInterceptor();
    mockHandler = MockErrorInterceptorHandler();
  });

  test('should map timeout DioException into NetworkException and reject', () {
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/products'),
      type: DioExceptionType.connectionTimeout,
    );

    when(() => mockHandler.reject(any())).thenReturn(null);

    interceptor.onError(dioError, mockHandler);

    final captured = verify(() => mockHandler.reject(captureAny())).captured;
    expect(captured.length, 1);
    final rejectedException = captured.first as DioException;
    expect(rejectedException.error, isA<NetworkException>());
  });

  test('should map 401 badResponse into AuthException and reject', () {
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/auth/profile'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/auth/profile'),
        statusCode: 401,
        data: {'message': 'Session expired'},
      ),
    );

    when(() => mockHandler.reject(any())).thenReturn(null);

    interceptor.onError(dioError, mockHandler);

    final captured = verify(() => mockHandler.reject(captureAny())).captured;
    expect(captured.length, 1);
    final rejectedException = captured.first as DioException;
    expect(rejectedException.error, isA<AuthException>());
    expect((rejectedException.error as AuthException).statusCode, 401);
  });
}
