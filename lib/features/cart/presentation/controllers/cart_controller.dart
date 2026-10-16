import 'package:get/get.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/cart_usecases.dart';

class CartController extends GetxController {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartController({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartQuantityUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
  });

  List<CartItemEntity> _items = [];
  String? _appliedPromo;
  double _discountPercent = 0.0;
  bool _isLoading = false;

  List<CartItemEntity> get items => _items;
  bool get isEmpty => _items.isEmpty;
  bool get isLoading => _isLoading;
  String? get appliedPromo => _appliedPromo;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * _discountPercent;

  double get taxAmount => (subtotal - discountAmount) * 0.05; // 5% GST/Tax

  double get shippingAmount => (subtotal > 100.0 || _items.isEmpty) ? 0.0 : 9.99;

  double get total => (subtotal - discountAmount + taxAmount + shippingAmount);

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    _isLoading = true;
    update([GetBuilderIds.cartList]);

    final result = await getCartUseCase(const NoParams());
    result.fold(
      (failure) => null,
      (loadedItems) {
        _items = loadedItems;
      },
    );

    _isLoading = false;
    update([
      GetBuilderIds.cartList,
      GetBuilderIds.cartBadge,
      GetBuilderIds.cartSummary,
    ]);
  }

  Future<void> addToCart(ProductEntity product, {int quantity = 1}) async {
    final result = await addToCartUseCase(AddToCartParams(product: product, quantity: quantity));
    result.fold(
      (failure) => null,
      (updatedItems) {
        _items = updatedItems;
        // Granular update of badge and summary
        update([
          GetBuilderIds.cartBadge,
          GetBuilderIds.cartList,
          GetBuilderIds.cartSummary,
        ]);
      },
    );
  }

  Future<void> incrementQuantity(String itemId) async {
    final item = _items.firstWhereOrNull((i) => i.id == itemId);
    if (item == null) return;

    final newQty = item.quantity + 1;
    final result = await updateCartQuantityUseCase(
      UpdateCartQuantityParams(itemId: itemId, quantity: newQty),
    );

    result.fold(
      (failure) => null,
      (updatedItems) {
        _items = updatedItems;
        update([
          GetBuilderIds.cartItemQuantity(itemId),
          GetBuilderIds.cartBadge,
          GetBuilderIds.cartSummary,
        ]);
      },
    );
  }

  Future<void> decrementQuantity(String itemId) async {
    final item = _items.firstWhereOrNull((i) => i.id == itemId);
    if (item == null) return;

    final newQty = item.quantity - 1;
    final result = await updateCartQuantityUseCase(
      UpdateCartQuantityParams(itemId: itemId, quantity: newQty),
    );

    result.fold(
      (failure) => null,
      (updatedItems) {
        _items = updatedItems;
        if (newQty <= 0) {
          update([
            GetBuilderIds.cartList,
            GetBuilderIds.cartBadge,
            GetBuilderIds.cartSummary,
          ]);
        } else {
          update([
            GetBuilderIds.cartItemQuantity(itemId),
            GetBuilderIds.cartBadge,
            GetBuilderIds.cartSummary,
          ]);
        }
      },
    );
  }

  Future<void> removeItem(String itemId) async {
    final result = await removeFromCartUseCase(itemId);
    result.fold(
      (failure) => null,
      (updatedItems) {
        _items = updatedItems;
        update([
          GetBuilderIds.cartList,
          GetBuilderIds.cartBadge,
          GetBuilderIds.cartSummary,
        ]);
      },
    );
  }

  bool applyPromo(String code) {
    final trimmed = code.trim().toUpperCase();
    if (trimmed == 'TRENDY30') {
      _appliedPromo = trimmed;
      _discountPercent = 0.30;
      update([GetBuilderIds.promoCodeSection, GetBuilderIds.cartSummary]);
      return true;
    } else if (trimmed == 'SAVE10') {
      _appliedPromo = trimmed;
      _discountPercent = 0.10;
      update([GetBuilderIds.promoCodeSection, GetBuilderIds.cartSummary]);
      return true;
    }
    return false;
  }

  void removePromo() {
    _appliedPromo = null;
    _discountPercent = 0.0;
    update([GetBuilderIds.promoCodeSection, GetBuilderIds.cartSummary]);
  }

  Future<void> clearCart() async {
    await clearCartUseCase(const NoParams());
    _items = [];
    _appliedPromo = null;
    _discountPercent = 0.0;
    update([
      GetBuilderIds.cartList,
      GetBuilderIds.cartBadge,
      GetBuilderIds.cartSummary,
      GetBuilderIds.promoCodeSection,
    ]);
  }
}
