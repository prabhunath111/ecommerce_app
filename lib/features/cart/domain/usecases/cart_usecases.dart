import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase implements UseCase<List<CartItemEntity>, NoParams> {
  final CartRepository repository;

  GetCartUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(NoParams params) {
    return repository.getCart();
  }
}

class AddToCartParams extends Equatable {
  final ProductEntity product;
  final int quantity;

  const AddToCartParams({required this.product, this.quantity = 1});

  @override
  List<Object?> get props => [product, quantity];
}

class AddToCartUseCase implements UseCase<List<CartItemEntity>, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(AddToCartParams params) {
    return repository.addToCart(params.product, quantity: params.quantity);
  }
}

class UpdateCartQuantityParams extends Equatable {
  final String itemId;
  final int quantity;

  const UpdateCartQuantityParams({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class UpdateCartQuantityUseCase implements UseCase<List<CartItemEntity>, UpdateCartQuantityParams> {
  final CartRepository repository;

  UpdateCartQuantityUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(UpdateCartQuantityParams params) {
    return repository.updateQuantity(params.itemId, params.quantity);
  }
}

class RemoveFromCartUseCase implements UseCase<List<CartItemEntity>, String> {
  final CartRepository repository;

  RemoveFromCartUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CartItemEntity>>> call(String itemId) {
    return repository.removeFromCart(itemId);
  }
}

class ClearCartUseCase implements UseCase<void, NoParams> {
  final CartRepository repository;

  ClearCartUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearCart();
  }
}
