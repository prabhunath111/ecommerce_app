import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({String? category, String? query});
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, bool>> toggleFavorite(String productId);
}
