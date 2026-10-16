import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final List<OrderEntity> _orders = [];

  @override
  Future<Either<Failure, OrderEntity>> placeOrder(OrderEntity order) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _orders.insert(0, order);
      return Right(order);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to place order: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory() async {
    try {
      return Right(_orders);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to retrieve order history: $e'));
    }
  }
}
