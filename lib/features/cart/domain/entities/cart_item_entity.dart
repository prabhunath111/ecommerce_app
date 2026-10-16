import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product_entity.dart';

class CartItemEntity extends Equatable {
  final String id;
  final ProductEntity product;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartItemEntity copyWith({
    String? id,
    ProductEntity? product,
    int? quantity,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity];
}

class CartSummaryEntity extends Equatable {
  final double subtotal;
  final double discount;
  final double tax;
  final double shipping;
  final double total;
  final String? promoCode;

  const CartSummaryEntity({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.shipping,
    required this.total,
    this.promoCode,
  });

  @override
  List<Object?> get props => [subtotal, discount, tax, shipping, total, promoCode];
}
