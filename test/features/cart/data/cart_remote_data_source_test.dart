import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/constants/api_endpoints.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/core/network/dio_client.dart';
import 'package:ecommerce_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late CartRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = CartRemoteDataSourceImpl(dioClient: mockDioClient);
  });

  const tProductId = '64f8a2d1b8d9c1e2a0f12345';
  const tQuantity = 2;

  final tSuccessResponse = {
    "success": true,
    "message": "Added to cart",
    "cart": {
      "items": [
        {
          "product": {
            "_id": "64f8a2d1b8d9c1e2a0f12345",
            "title": "Sample Product",
            "price": 299
          },
          "quantity": 2,
          "subtotal": 598
        }
      ],
      "totalItems": 1,
      "totalPrice": 598
    }
  };

  test('should return response data when API call to /api/cart/add is successful', () async {
    // Arrange
    when(() => mockDioClient.post<dynamic>(
          ApiEndpoints.addToCart,
          data: {'productId': tProductId, 'quantity': tQuantity},
        )).thenAnswer((_) async => Response(
          data: tSuccessResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.addToCart),
        ));

    // Act
    final result = await dataSource.addToCart(productId: tProductId, quantity: tQuantity);

    // Assert
    expect(result, tSuccessResponse);
    verify(() => mockDioClient.post<dynamic>(
          ApiEndpoints.addToCart,
          data: {'productId': tProductId, 'quantity': tQuantity},
        )).called(1);
  });

  test('should throw ServerException when response success is false', () async {
    // Arrange
    final tFailureResponse = {
      "success": false,
      "message": "quantity must be at least 1"
    };

    when(() => mockDioClient.post<dynamic>(
          ApiEndpoints.addToCart,
          data: {'productId': tProductId, 'quantity': 0},
        )).thenAnswer((_) async => Response(
          data: tFailureResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.addToCart),
        ));

    // Act & Assert
    expect(
      () => dataSource.addToCart(productId: tProductId, quantity: 0),
      throwsA(isA<ServerException>().having((e) => e.message, 'message', 'quantity must be at least 1')),
    );
  });
}
