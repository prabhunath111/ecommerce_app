import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, OrderEntity>> placeOrder(OrderEntity order);
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory();
}
