import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecommerce_app/features/cart/domain/usecases/cart_usecases.dart';
import 'package:ecommerce_app/features/cart/presentation/controllers/cart_controller.dart';
import 'package:ecommerce_app/features/products/domain/entities/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCartUseCase extends Mock implements GetCartUseCase {}
class MockAddToCartUseCase extends Mock implements AddToCartUseCase {}
class MockUpdateCartQuantityUseCase extends Mock implements UpdateCartQuantityUseCase {}
class MockRemoveFromCartUseCase extends Mock implements RemoveFromCartUseCase {}
class MockClearCartUseCase extends Mock implements ClearCartUseCase {}

void main() {
  late CartController controller;
  late MockGetCartUseCase mockGetCartUseCase;
  late MockAddToCartUseCase mockAddToCartUseCase;
  late MockUpdateCartQuantityUseCase mockUpdateCartQuantityUseCase;
  late MockRemoveFromCartUseCase mockRemoveFromCartUseCase;
  late MockClearCartUseCase mockClearCartUseCase;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const AddToCartParams(
        product: ProductEntity(
          id: 'p1',
          title: 'Fall Jacket',
          price: 50.0,
          description: 'd',
          category: 'c',
          image: 'i',
          rating: 4.0,
          ratingCount: 10,
        ),
      ),
    );
  });

  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockAddToCartUseCase = MockAddToCartUseCase();
    mockUpdateCartQuantityUseCase = MockUpdateCartQuantityUseCase();
    mockRemoveFromCartUseCase = MockRemoveFromCartUseCase();
    mockClearCartUseCase = MockClearCartUseCase();

    when(() => mockGetCartUseCase(any())).thenAnswer((_) async => const Right([]));

    controller = CartController(
      getCartUseCase: mockGetCartUseCase,
      addToCartUseCase: mockAddToCartUseCase,
      updateCartQuantityUseCase: mockUpdateCartQuantityUseCase,
      removeFromCartUseCase: mockRemoveFromCartUseCase,
      clearCartUseCase: mockClearCartUseCase,
    );
  });

  const tProduct = ProductEntity(
    id: 'prod_1',
    title: 'Sweater',
    price: 100.0,
    description: 'Warm sweater',
    category: "men's clothing",
    image: 'https://example.com/sweater.jpg',
    rating: 4.5,
    ratingCount: 20,
  );

  test('initial state should be empty with zero total', () {
    expect(controller.isEmpty, true);
    expect(controller.subtotal, 0.0);
    expect(controller.totalQuantity, 0);
  });

  test('adding an item should update items, subtotal and totals correctly', () async {
    const tItem = CartItemEntity(id: 'cart_1', product: tProduct, quantity: 2);
    when(() => mockAddToCartUseCase(any())).thenAnswer((_) async => const Right([tItem]));

    await controller.addToCart(tProduct, quantity: 2);

    expect(controller.items.length, 1);
    expect(controller.totalQuantity, 2);
    expect(controller.subtotal, 200.0); // 100 * 2
    expect(controller.shippingAmount, 0.0); // subtotal > 100 -> free shipping
    expect(controller.taxAmount, 10.0); // 5% of 200 = 10
    expect(controller.total, 210.0);
  });

  test('applying promo code TRENDY30 should apply 30% discount', () async {
    const tItem = CartItemEntity(id: 'cart_1', product: tProduct, quantity: 1);
    when(() => mockAddToCartUseCase(any())).thenAnswer((_) async => const Right([tItem]));

    await controller.addToCart(tProduct, quantity: 1);
    expect(controller.subtotal, 100.0);

    final applied = controller.applyPromo('TRENDY30');

    expect(applied, true);
    expect(controller.appliedPromo, 'TRENDY30');
    expect(controller.discountAmount, 30.0); // 30% of 100
    // Tax is 5% of (100 - 30) = 3.5
    expect(controller.taxAmount, 3.5);
  });

  test('clearCart should clear items and reset promo', () async {
    when(() => mockClearCartUseCase(any())).thenAnswer((_) async => const Right(null));

    await controller.clearCart();

    expect(controller.isEmpty, true);
    expect(controller.appliedPromo, null);
    expect(controller.total, 0.0);
  });
}
