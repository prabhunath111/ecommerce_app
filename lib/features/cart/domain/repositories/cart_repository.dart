import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCart();
  Future<Either<Failure, List<CartItemEntity>>> addToCart(ProductEntity product, {int quantity = 1});
  Future<Either<Failure, List<CartItemEntity>>> updateQuantity(String itemId, int quantity);
  Future<Either<Failure, List<CartItemEntity>>> removeFromCart(String itemId);
  Future<Either<Failure, void>> clearCart();
}
