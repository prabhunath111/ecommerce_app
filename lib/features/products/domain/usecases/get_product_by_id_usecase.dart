import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUseCase implements UseCase<ProductEntity, String> {
  final ProductRepository repository;

  GetProductByIdUseCase({required this.repository});

  @override
  Future<Either<Failure, ProductEntity>> call(String id) {
    return repository.getProductById(id);
  }
}
