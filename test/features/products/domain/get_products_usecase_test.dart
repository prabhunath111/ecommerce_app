import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(repository: mockRepository);
  });

  const tProduct = ProductEntity(
    id: 'prod_1',
    title: 'Modern Jacket',
    price: 49.99,
    description: 'A stylish and cozy jacket',
    category: "men's clothing",
    image: 'https://example.com/image.jpg',
    rating: 4.5,
    ratingCount: 120,
  );

  test('should return list of products from repository', () async {
    // Arrange
    when(() => mockRepository.getProducts(
      category: any(named: 'category'),
      query: any(named: 'query'),
      page: any(named: 'page'),
      limit: any(named: 'limit'),
    )).thenAnswer((_) async => const Right([tProduct]));

    // Act
    final result = await useCase(const GetProductsParams(category: 'all', query: ''));

    // Assert
    expect(result, const Right([tProduct]));
    verify(() => mockRepository.getProducts(category: 'all', query: '', page: 1, limit: 10)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // Arrange
    const tFailure = ServerFailure(message: 'Server error');
    when(() => mockRepository.getProducts(
      category: any(named: 'category'),
      query: any(named: 'query'),
      page: any(named: 'page'),
      limit: any(named: 'limit'),
    )).thenAnswer((_) async => const Left(tFailure));

    // Act
    final result = await useCase(const GetProductsParams());

    // Assert
    expect(result, const Left(tFailure));
  });
}
