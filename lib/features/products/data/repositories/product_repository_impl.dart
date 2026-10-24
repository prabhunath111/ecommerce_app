import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final Set<String> _favoriteProductIds = {};

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? category,
    String? query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      if (page == 1) {
        try {
          final favIds = await remoteDataSource.getFavoriteProductIds();
          _favoriteProductIds.clear();
          _favoriteProductIds.addAll(favIds);
        } catch (_) {}
      }

      final models = await remoteDataSource.getProducts(
        category: category,
        query: query,
        page: page,
        limit: limit,
      );
      final entities = models.map((m) {
        return m.copyWith(isFavorite: _favoriteProductIds.contains(m.id));
      }).toList();
      return Right(entities);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      return Right(model.copyWith(isFavorite: _favoriteProductIds.contains(model.id)));
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String productId) async {
    try {
      bool isFav;
      try {
        isFav = await remoteDataSource.toggleFavorite(productId);
      } catch (_) {
        // Fallback to local state if network call fails or offline
        if (_favoriteProductIds.contains(productId)) {
          _favoriteProductIds.remove(productId);
          isFav = false;
        } else {
          _favoriteProductIds.add(productId);
          isFav = true;
        }
      }

      if (isFav) {
        _favoriteProductIds.add(productId);
      } else {
        _favoriteProductIds.remove(productId);
      }

      return Right(isFav);
    } on AppException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Set<String>>> getFavoriteProductIds() async {
    try {
      final favIds = await remoteDataSource.getFavoriteProductIds();
      _favoriteProductIds.clear();
      _favoriteProductIds.addAll(favIds);
      return Right(_favoriteProductIds);
    } catch (e) {
      return Right(_favoriteProductIds);
    }
  }
}
