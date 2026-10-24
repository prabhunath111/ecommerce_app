import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';

abstract class CartRemoteDataSource {
  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final DioClient dioClient;

  CartRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> addToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.addToCart,
        data: {
          'productId': productId,
          'quantity': quantity,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data['success'] == true) {
          return data;
        } else {
          throw ServerException(
            message: data['message']?.toString() ?? 'Failed to add item to cart',
          );
        }
      } else {
        throw ServerException(message: 'Invalid response format from server');
      }
    } on DioException catch (dioErr) {
      if (dioErr.error is AppException) {
        throw dioErr.error as AppException;
      }
      throw ServerException(message: dioErr.message ?? 'Failed to add item to cart');
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
