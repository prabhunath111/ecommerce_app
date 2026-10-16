import '../../../products/data/models/product_model.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': (product is ProductModel)
          ? (product as ProductModel).toJson()
          : ProductModel(
              id: product.id,
              title: product.title,
              price: product.price,
              originalPrice: product.originalPrice,
              description: product.description,
              category: product.category,
              image: product.image,
              rating: product.rating,
              ratingCount: product.ratingCount,
              isFavorite: product.isFavorite,
            ).toJson(),
      'quantity': quantity,
    };
  }
}
