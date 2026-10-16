import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/checkout_repository.dart';

class PlaceOrderUseCase implements UseCase<OrderEntity, OrderEntity> {
  final CheckoutRepository repository;

  PlaceOrderUseCase({required this.repository});

  @override
  Future<Either<Failure, OrderEntity>> call(OrderEntity params) {
    return repository.placeOrder(params);
  }
}

class GetOrderHistoryUseCase implements UseCase<List<OrderEntity>, NoParams> {
  final CheckoutRepository repository;

  GetOrderHistoryUseCase({required this.repository});

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) {
    return repository.getOrderHistory();
  }
}
