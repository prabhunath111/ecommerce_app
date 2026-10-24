import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/constants/api_endpoints.dart';
import 'package:ecommerce_app/core/network/dio_client.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockDioClient mockDioClient;

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = ProductRemoteDataSourceImpl(dioClient: mockDioClient);
  });

  const tProductId = 'prod_123';

  test('should return true when API toggleFavorite response is success', () async {
    // Arrange
    when(() => mockDioClient.post<dynamic>(
          ApiEndpoints.toggleFavorite,
          data: {'productId': tProductId},
        )).thenAnswer((_) async => Response(
          data: {'success': true, 'isFavorite': true},
          statusCode: 200,
          requestOptions: RequestOptions(path: ApiEndpoints.toggleFavorite),
        ));

    // Act
    final result = await dataSource.toggleFavorite(tProductId);

    // Assert
    expect(result, true);
    verify(() => mockDioClient.post<dynamic>(
          ApiEndpoints.toggleFavorite,
          data: {'productId': tProductId},
        )).called(1);
  });

  test('should return set of favorite IDs when GET /api/favorites returns items', () async {
    // Arrange
    when(() => mockDioClient.get<dynamic>(ApiEndpoints.favorites))
        .thenAnswer((_) async => Response(
              data: [
                {'_id': 'fav_1', 'title': 'Fav 1'},
                {'_id': 'fav_2', 'title': 'Fav 2'},
              ],
              statusCode: 200,
              requestOptions: RequestOptions(path: ApiEndpoints.favorites),
            ));

    // Act
    final result = await dataSource.getFavoriteProductIds();

    // Assert
    expect(result, containsAll({'fav_1', 'fav_2'}));
    verify(() => mockDioClient.get<dynamic>(ApiEndpoints.favorites)).called(1);
  });
}
