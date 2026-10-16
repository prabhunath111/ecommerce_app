import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCart() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> addToCart(
    ProductEntity product, {
    int quantity = 1,
  }) async {
    try {
      final items = await localDataSource.getCartItems();
      final index = items.indexWhere((i) => i.product.id == product.id);

      if (index != -1) {
        final existing = items[index];
        items[index] = CartItemModel(
          id: existing.id,
          product: existing.product,
          quantity: existing.quantity + quantity,
        );
      } else {
        items.add(
          CartItemModel(
            id: 'cart_${product.id}',
            product: product is ProductModel
                ? product
                : ProductModel(
                    id: product.id,
                    title: product.title,
                    price: product.price,
                    originalPrice: product.originalPrice,
                    description: product.description,
                    category: product.category,
                    image: product.image,
                    rating: product.rating,
                    ratingCount: product.ratingCount,
                    isFavorite: product.isFavorite,
                  ),
            quantity: quantity,
          ),
        );
      }

      await localDataSource.saveCartItems(items);
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> updateQuantity(
    String itemId,
    int quantity,
  ) async {
    try {
      final items = await localDataSource.getCartItems();
      if (quantity <= 0) {
        items.removeWhere((i) => i.id == itemId);
      } else {
        final index = items.indexWhere((i) => i.id == itemId);
        if (index != -1) {
          items[index] = CartItemModel(
            id: items[index].id,
            product: items[index].product,
            quantity: quantity,
          );
        }
      }

      await localDataSource.saveCartItems(items);
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> removeFromCart(String itemId) async {
    try {
      final items = await localDataSource.getCartItems();
      items.removeWhere((i) => i.id == itemId);
      await localDataSource.saveCartItems(items);
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
