import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/product_repository.dart';

class ToggleFavoriteUseCase implements UseCase<bool, String> {
  final ProductRepository repository;

  ToggleFavoriteUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(String productId) {
    return repository.toggleFavorite(productId);
  }
}
