import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecommerce_app/features/cart/domain/usecases/cart_usecases.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCartRepository extends Mock implements CartRepository {}

void main() {
  late AddToCartUseCase addToCartUseCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    addToCartUseCase = AddToCartUseCase(repository: mockRepository);
  });

  const tProduct = ProductEntity(
    id: 'prod_10',
    title: 'Sneakers',
    price: 89.0,
    description: 'Shoes',
    category: 'footwear',
    image: 'https://example.com/shoes.jpg',
    rating: 4.8,
    ratingCount: 50,
  );

  const tCartItem = CartItemEntity(id: 'cart_prod_10', product: tProduct, quantity: 2);

  test('should add item to cart and return updated items list', () async {
    // Arrange
    when(() => mockRepository.addToCart(tProduct, quantity: 2))
        .thenAnswer((_) async => const Right([tCartItem]));

    // Act
    final result = await addToCartUseCase(const AddToCartParams(product: tProduct, quantity: 2));

    // Assert
    expect(result, const Right([tCartItem]));
    verify(() => mockRepository.addToCart(tProduct, quantity: 2)).called(1);
  });
}
